package com.zifras

import grails.plugin.springsecurity.SpringSecurityService
import com.zifras.User

class AccessRulesService {

    def springSecurityService
		
	def getCurrentUser(){
		def user = springSecurityService.currentUser
		if(user!=null)
			user = User.get(user.id)
		/*
		if(!isAdminRole(user)){
			user = User.get(user.id)
		}else{
			user = Admin.get(user.id)
		}
		*/
		user
	}
	
	def isAdmin(){
		def user = springSecurityService.currentUser
		if(!isAdminRole(user)){
			return false;
		}else{
			return true;
		}
	}
	
	private boolean isAdminRole(user){
		return user.authorities.contains(SecRole.findByAuthority('ROLE_ADMIN'))
	}
}
