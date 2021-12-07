package com.zifras.security

import com.zifras.JwtCookieTokenReader
import com.zifras.cuenta.CuentaService
import com.zifras.notificacion.NotificacionService
import com.zifras.BitrixService

import grails.config.Config
import grails.core.support.GrailsConfigurationAware
import grails.plugin.springsecurity.annotation.Secured
import grails.plugin.springsecurity.rest.oauth.OauthUser
import grails.plugin.springsecurity.rest.oauth.OauthUserDetailsService
import grails.plugin.springsecurity.rest.token.reader.TokenReader
import groovy.util.logging.Slf4j
import javax.servlet.http.Cookie
import org.pac4j.core.profile.CommonProfile
import org.springframework.security.core.GrantedAuthority


@Slf4j
class AuthController implements GrailsConfigurationAware {

    String grailsServerUrl
    TokenReader tokenReader
    def bitrixService
    def cuentaService
    def notificacionService
    def springSecurityService
    int jwtExpiration

    static allowedMethods = [
            success: 'GET',
            logout: 'POST'
    ]

    @Secured('permitAll')
    def success(String token) {
        
        if(springSecurityService.principal.getClass() == grails.plugin.springsecurity.rest.oauth.OauthUser){
            def command = new RegisterCommand()
            command.password = "asdf1234"
            command.password2 = "asdf1234"
            command.nombre = springSecurityService.principal.userProfile.getFirstName()
            command.apellido = springSecurityService.principal.userProfile.getFamilyName()
            command.username = springSecurityService.principal.userProfile.getEmail()
    
            if(!cuentaService.existeCuenta(command)){
                bitrixService.guardarEnBitrix(command, cuentaService.registrarCuenta(command),"Registro Normal",null)
                try {
                    User.findByUsername(command.username).with{
                        accountLocked = false
                        save(flush:true)
                    }
                }
                catch(Exception ep) {
                }
            }
            
            springSecurityService.reauthenticate(command.username)
        }
        
        // log.debug('token value {}', token)

        if (token) {
            Cookie cookie = jwtCookie(token)
            response.addCookie(cookie) 
        }
        

        redirect(controller:"dashboard",action:"index")
        
    }

    @Secured('permitAll')
    def successApp(String token) {
        def url = "calimapp://calimapp.com.ar/auth-google/" + token

        println "Ingreso via google desde APP mobile"
        //Si el usuario no existe se crea
        if(springSecurityService.principal.getClass() == grails.plugin.springsecurity.rest.oauth.OauthUser){
            def command = new RegisterCommand()
            command.password = "asdf1234"
            command.password2 = "asdf1234"
            command.nombre = springSecurityService.principal.userProfile.getFirstName()
            command.apellido = springSecurityService.principal.userProfile.getFamilyName()
            command.username = springSecurityService.principal.userProfile.getEmail()
    
            if(!cuentaService.existeCuenta(command)){
                bitrixService.guardarEnBitrix(command, cuentaService.registrarCuenta(command),"Registro Normal",null)
                try {
                    User.findByUsername(command.username).with{
                        accountLocked = false
                        save(flush:true)
                    }
                }
                catch(Exception ep) {
                }
            }
        }

        redirect(url: url)
    }

    protected Cookie jwtCookie(String tokenValue) {
        Cookie jwtCookie = new Cookie( cookieName(), tokenValue )
        jwtCookie.maxAge = jwtExpiration 
        jwtCookie.path = '/'
        jwtCookie.setHttpOnly(true) 
        if ( httpOnly() ) {
            jwtCookie.setSecure(true) 
        }
        jwtCookie
    }

    @Override
    void setConfiguration(Config co) {
        jwtExpiration = co.getProperty('grails.plugin.springsecurity.rest.token.storage.memcached.expiration', Integer, 3600) 
        grailsServerUrl = co.getProperty('grails.serverURL', String)
    }

    protected boolean httpOnly() {
        grailsServerUrl?.startsWith('https')
    }

    protected String cookieName() {
        if ( tokenReader instanceof JwtCookieTokenReader ) {
            return ((JwtCookieTokenReader) tokenReader).cookieName  
        }
        return 'jwt'
    }
}