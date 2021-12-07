package com.zifras

import grails.testing.web.interceptor.InterceptorUnitTest
import spock.lang.Specification

class FirstInterceptorSpec extends Specification implements InterceptorUnitTest<FirstInterceptor> {

    def setup() {
    }

    def cleanup() {

    }

    void "Test first interceptor matching"() {
        when:"A request matches the interceptor"
            withRequest(controller:"first")

        then:"The interceptor does match"
            interceptor.doesMatch()
    }
}
