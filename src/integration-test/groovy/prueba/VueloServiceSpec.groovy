package prueba

import grails.testing.mixin.integration.Integration
import grails.gorm.transactions.Rollback
import spock.lang.Specification
import org.hibernate.SessionFactory

@Integration
@Rollback
class VueloServiceSpec extends Specification {

    VueloService vueloService
    SessionFactory sessionFactory

    private Long setupData() {
        // TODO: Populate valid domain instances and return a valid ID
        //new Vuelo(...).save(flush: true, failOnError: true)
        //new Vuelo(...).save(flush: true, failOnError: true)
        //Vuelo vuelo = new Vuelo(...).save(flush: true, failOnError: true)
        //new Vuelo(...).save(flush: true, failOnError: true)
        //new Vuelo(...).save(flush: true, failOnError: true)
        assert false, "TODO: Provide a setupData() implementation for this generated test suite"
        //vuelo.id
    }

    void "test get"() {
        setupData()

        expect:
        vueloService.get(1) != null
    }

    void "test list"() {
        setupData()

        when:
        List<Vuelo> vueloList = vueloService.list(max: 2, offset: 2)

        then:
        vueloList.size() == 2
        assert false, "TODO: Verify the correct instances are returned"
    }

    void "test count"() {
        setupData()

        expect:
        vueloService.count() == 5
    }

    void "test delete"() {
        Long vueloId = setupData()

        expect:
        vueloService.count() == 5

        when:
        vueloService.delete(vueloId)
        sessionFactory.currentSession.flush()

        then:
        vueloService.count() == 4
    }

    void "test save"() {
        when:
        assert false, "TODO: Provide a valid instance to save"
        Vuelo vuelo = new Vuelo()
        vueloService.save(vuelo)

        then:
        vuelo.id != null
    }
}
