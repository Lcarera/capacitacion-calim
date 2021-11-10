package prueba

import grails.validation.ValidationException
import static org.springframework.http.HttpStatus.*

class VueloController {

    VueloService vueloService

    static allowedMethods = [save: "POST", update: "PUT", delete: "DELETE"]

    def index(Integer max) {
        params.max = Math.min(max ?: 10, 100)
        respond vueloService.list(params), model:[vueloCount: vueloService.count()]
    }

    def show(Long id) {
        respond vueloService.get(id)
    }

    def create() {
        respond new Vuelo(params)
    }

    def save(Vuelo vuelo) {
        if (vuelo == null) {
            notFound()
            return
        }

        try {
            vueloService.save(vuelo)
        } catch (ValidationException e) {
            respond vuelo.errors, view:'create'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.created.message', args: [message(code: 'vuelo.label', default: 'Vuelo'), vuelo.id])
                redirect vuelo
            }
            '*' { respond vuelo, [status: CREATED] }
        }
    }

    def edit(Long id) {
        respond vueloService.get(id)
    }

    def update(Vuelo vuelo) {
        if (vuelo == null) {
            notFound()
            return
        }

        try {
            vueloService.save(vuelo)
        } catch (ValidationException e) {
            respond vuelo.errors, view:'edit'
            return
        }

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.updated.message', args: [message(code: 'vuelo.label', default: 'Vuelo'), vuelo.id])
                redirect vuelo
            }
            '*'{ respond vuelo, [status: OK] }
        }
    }

    def delete(Long id) {
        if (id == null) {
            notFound()
            return
        }

        vueloService.delete(id)

        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.deleted.message', args: [message(code: 'vuelo.label', default: 'Vuelo'), id])
                redirect action:"index", method:"GET"
            }
            '*'{ render status: NO_CONTENT }
        }
    }

    protected void notFound() {
        request.withFormat {
            form multipartForm {
                flash.message = message(code: 'default.not.found.message', args: [message(code: 'vuelo.label', default: 'Vuelo'), params.id])
                redirect action: "index", method: "GET"
            }
            '*'{ render status: NOT_FOUND }
        }
    }
}
