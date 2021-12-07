package com.zifras

class UrlMappings {

    static mappings = {
        "/pagocuenta/notificacionmp"(controller: "pagoCuenta", action: "notificacionMP")
        "/api/$controller/$action?/$id?"()

        "/$controller/$action?/$id?(.$format)?"{
            constraints {
                // apply constraints here
            }
        }

        "/"(controller: "login", action: "index")
		"/index"(controller: "login", action: "index")
        "500"(view:'/error')
        "404"(view:'/notFound')
    }
}
