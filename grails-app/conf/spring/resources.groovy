package spring

import com.zifras.UserPasswordEncoderListener

import com.zifras.CurrentUserTenantResolver

import com.zifras.JwtCookieTokenReader
import org.springframework.security.web.authentication.logout.CookieClearingLogoutHandler
import com.zifras.GoogleUserDetailService

// Place your Spring DSL code here
beans = {

    userPasswordEncoderListener(UserPasswordEncoderListener)
	localeResolver(org.springframework.web.servlet.i18n.SessionLocaleResolver){
		defaultLocale= new java.util.Locale('es');
	}
	currentUserTenantResolver(CurrentUserTenantResolver)
	//tenantRepository(com.zifras.CachingTenantRepository)
/*
	tokenReader(JwtCookieTokenReader) {
	    cookieName = 'jwt'
	}
*/
	cookieClearingLogoutHandler(CookieClearingLogoutHandler, ['jwt'])

	oauthUserDetailsService(GoogleUserDetailService)
}


// Activate these bean definitions
// Documentation http://grails.org/doc/latest/guide/single.html#14.2%20Configuring%20Additional%20Beans
// tenantResolver(com.zifras.DomainTenantResolver)
// tenantRepository(com.zifras.CachingTenantRepository)
