package prueba

import grails.gorm.services.Service

@Service(Vuelo)
interface VueloService {

    Vuelo get(Serializable id)

    List<Vuelo> list(Map args)

    Long count()

    void delete(Serializable id)

    Vuelo save(Vuelo vuelo)

}