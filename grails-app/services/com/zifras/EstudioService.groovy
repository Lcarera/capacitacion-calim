package com.zifras

// import grails.validation.ValidationException
import grails.transaction.Transactional

@Transactional
class EstudioService {
	def contarChromes(Boolean abierto){
		Estudio.get(2).with{
			if (abierto)
				chromedriversAbiertos++
			else
				chromedriversCerrados++
			save(flush:true)
		}
	}
}