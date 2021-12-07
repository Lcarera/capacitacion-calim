package com.zifras

import com.zifras.AccessRulesService
import com.zifras.Estudio
import com.zifras.Role
import com.zifras.User
import com.zifras.UserRole
import com.zifras.UsuarioCommand
import com.zifras.cuenta.Cuenta
import com.zifras.notificacion.NotificacionService
import com.zifras.notificacion.NotificacionTemplate
import static com.zifras.security.RegistrarController.*

import grails.plugin.springsecurity.SpringSecurityUtils
import grails.plugin.springsecurity.ui.RegistrationCode
import grails.transaction.Transactional
import grails.validation.ValidationException
import grails.web.mapping.LinkGenerator
import org.joda.time.LocalDateTime
import org.springframework.context.MessageSource
import org.springframework.context.i18n.LocaleContextHolder
import static grails.gorm.multitenancy.Tenants.*

@Transactional
class UsuarioService {
	def sessionFactory
	AccessRulesService accessRulesService
	MessageSource messageSource
	def grailsApplication
	def notificacionService
	def passwordEncoder
    static LinkGenerator grailsLinkGenerator
    def mailService

	def createUsuarioCommand(){
		def command = new UsuarioCommand()
		command.passwordExpired = false
		command.accountExpired = false
		command.accountLocked = false
		command.userTenantId = 1
		return command
	}

	def crearUsuarioParaCuenta(Cuenta cuenta,String password=null){
		def command = createUsuarioCommand()
		command.userTenantId = 2
		command.roleId = Role.findByAuthority('ROLE_CUENTA').id
		command.username = cuenta.email
		command.cuentaId = cuenta.id
		saveUsuario(command, password)
	}

	def listUsuario(Boolean conCuenta) {
		String query = """
			SELECT users.id, 
			       username, 
			       user_tenant_id, 
			       authority, 
			       enabled 
			FROM   users 
			       LEFT JOIN user_role 
			              ON user_role.user_id = users.id 
			       LEFT JOIN role 
			              ON user_role.role_id = role.id 
			WHERE  cuenta_id IS """ + (conCuenta ? 'NOT' : '') + " NULL;"
		return sessionFactory.currentSession.createSQLQuery(query).list().collect{
			def item = [:]
			item.id = it[0]
			item.username = it[1]
			item.estudioNombre = it[2] == 2 ? "Calim" : "Pavoni"
			item.roleText = it[3]
			item.enabledText = it[4] ? "Sí" : "No"
			return item
		}
	}

	def listAdmins(){
		return UserRole.findAllByRole(Role.findByAuthority('ROLE_ADMIN')).collect{it.user}
	}

	def changePassword(Long userId, String password, String password2, String  passwordViejo) {
		User usuarioInstance = User.get(userId)

		if (userId != accessRulesService.getCurrentUser().id)
			throw new Exception('permiso')
		if (! passwordEncoder.isPasswordValid(usuarioInstance.password, passwordViejo, null))
			throw new Exception('vieja')
		if (!checkPasswordMinLength(password, null))
			throw new Exception('corta')
		if (!checkPasswordMaxLength(password, null))
			throw new Exception('larga')
		if (checkPasswordRegex(password, null))
			throw new Exception('regex')
		if (password != password2)
			throw new Exception('nuevas')

		usuarioInstance.password = password
		usuarioInstance.save(flush:true, failOnError:true)
	}

	def listRolesBackoffice() {
		def lista
		lista = Role.createCriteria().list() {
			and{
				ne("authority",'ROLE_CUENTA')
			}
		}
		return lista
	}

	def listRoles() {
		def lista
		lista = Role.list()
		return lista
	}

	def getUsuario(Long id){
		def usuarioInstance = User.get(id)
	}

	def getUsuario(String email){
		def usuarioInstance = User.findByUsername(email)
	}

	def getUsuarioPorCuenta(String cuentaId){
		return User.findByCuenta(Cuenta.get(cuentaId))
	}

	def getRol(Long id){
		def roleInstance = Role.get(id)
	}

	def getUsuarioCommand(Long id){
		def usuarioInstance = User.get(id)

		return (usuarioInstance) ? pasarDatos(usuarioInstance, createUsuarioCommand()) : null
	}

	def getUsuarioList() {
		def lista = User.list();
	}

	def cambiarTenant(){
		def currentUser = accessRulesService.getCurrentUser()
		currentUser.userTenantId = (currentUser.userTenantId == 2) ? 1 : 2
		currentUser.save(flush:true, failOnError:true)
	}

	def deleteUsuario(Long id){
		def usuarioInstance = User.get(id)

		UserRole.findAllByUser(usuarioInstance)*.delete(flush:true)
		UserTrack.findAllByUser(usuarioInstance)*.delete(flush:true)

		usuarioInstance.delete(flush:true)
	}

	def saveUsuario(UsuarioCommand command, String password=null){
		def usuarioInstance = pasarDatos(command, new User())

		if(password!=null) //si el password es distinto null significa que creo via registro
			usuarioInstance.accountLocked = true  //y empieza cn la cuenta bloqueada hasta q la verifique

		usuarioInstance.password = password?: "cuentaNuev4Calim"

		usuarioInstance.save(flush:true, failOnError:true)

		def userRole = new UserRole()
		userRole.user = usuarioInstance
		userRole.role = Role.get(command.roleId)
		userRole.save(flush:true)

		if(password==null)
			enviarMailReseteoPassword(usuarioInstance.id, !!usuarioInstance.cuenta?.tokenTiendaNube)

		return usuarioInstance
	}

	def updateUsuario(UsuarioCommand command){
		def usuarioInstance = User.get(command.usuarioId)

		if (command.version != null) {
			if (usuarioInstance.version > command.version) {
				UsuarioCommand.errors.rejectValue("version", "default.optimistic.locking.failure",["User"] as Object[],
					"Mientras usted editaba, otro usuario ha actualizado la usuario")
				throw new ValidationException("Error de versión", UsuarioCommand.errors)
			}
		}

		usuarioInstance = pasarDatos(command, usuarioInstance).save(flush:false)

			def rolDeCommand = Role.get(command.roleId)
			if (rolDeCommand && usuarioInstance.authorities?.first().id != command.roleId){
				UserRole.findAllByUser(usuarioInstance).each{
					it.delete(flush:false)
				}
				def userRole = new UserRole()
				userRole.user = usuarioInstance
				userRole.role = rolDeCommand
				userRole.save(flush:false)
			}

		return usuarioInstance.save(flush:true, failOnError:true)
	}

	def getCantidadUsuariosTotales(){
		return User.count()
	}

	def pasarDatos(origen,destino){
		destino.userTenantId = origen.userTenantId
		destino.username = origen.username
		destino.enabled = origen.enabled
		destino.accountExpired = origen.accountExpired
		destino.accountLocked = origen.accountLocked
		destino.passwordExpired = origen.passwordExpired

		if (destino instanceof UsuarioCommand){
			destino.usuarioId = origen.id
			destino.version = origen.version
			destino.roleId = origen.authorities.first().id
			if(origen.cuenta!=null)
				destino.cuentaId = origen.cuenta.id
			else
				destino.cuentaId = null
		}else{
			// El rol no se asigna acá porque depende de si es create o update
			destino.cuenta = Cuenta.get(origen.cuentaId)
		}

		return destino
	}

	def bloquearDesbloquear(Long id){
		User usuarioInstance = User.get(id)
		usuarioInstance.enabled = !(usuarioInstance.enabled)
		return usuarioInstance.save(flush:true, failOnError:true)
	}

	def enviarMailReseteoPassword(Long userId, Boolean tiendaNube = false){
		User usuario = User.get(userId)
		usuario.passwordExpired = true
		usuario.save(flush:true, failOnError:true)

		String url = getLinkResetPassword(usuario)
		String urlNotificaciones = getLinkDesactivarNotificaciones(usuario)

		//def body = messageSource.getMessage('calim.register.manual.email.body', [url, urlNotificaciones] as Object[], '', LocaleContextHolder.locale)
		//def asunto = messageSource.getMessage('calim.register.manual.email.subject', [] as Object[], '', LocaleContextHolder.locale)
		
		NotificacionTemplate plantilla
		String bodyMail
		def horaProgramada = null;
		if (tiendaNube){
			plantilla = NotificacionTemplate.findByNombre("Registro TiendaNube")
			bodyMail = plantilla.llenarVariablesBody([usuario.cuenta?.nombreApellido, url, urlNotificaciones])
		}
		else{
			plantilla = NotificacionTemplate.findByNombre("Email Registro Manual")
			if (usuario.cuenta)
				horaProgramada = new LocalDateTime().plusHours(1)
			bodyMail = plantilla.llenarVariablesBody([url,urlNotificaciones])
		}

		notificacionService.enviarEmail(usuario.username, plantilla.asuntoEmail, bodyMail, 'registroManual', horaProgramada, plantilla.tituloApp, plantilla.textoApp)
	}

	def existeUsuario(String email){
		def estudioCalim = Estudio.findByNombre('Calim')
		withId(new Integer(estudioCalim.id.toString())) {
			return User.findAllByUsername(email).size() > 0
		}
	}

	public static String getLinkDesactivarNotificaciones(User usuario){
		grailsLinkGenerator.link(controller: 'notificacion', action: 'desactivarNotificaciones', absolute: true, params:['p1': usuario.id, 'p2': usuario.cuenta?.id])
	}

	public static String getLinkResetPassword(User usuario){
		RegistrationCode registrationCode = new RegistrationCode(username: usuario.username)
		registrationCode.save(flush: true)
		return grailsLinkGenerator.link(controller: 'registrar', action: 'resetPassword', absolute: true, params:['t': registrationCode.token])
	}
}