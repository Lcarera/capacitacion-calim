package com.zifras

import grails.plugin.springsecurity.annotation.Secured;
import grails.converters.JSON

import com.google.api.client.auth.oauth2.Credential;
import com.google.api.client.extensions.java6.auth.oauth2.AuthorizationCodeInstalledApp;
import com.google.api.client.extensions.jetty.auth.oauth2.LocalServerReceiver;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.googleapis.auth.oauth2.GoogleCredential;
import com.google.api.client.googleapis.auth.oauth2.GoogleClientSecrets;
import com.google.api.client.googleapis.javanet.GoogleNetHttpTransport;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.JsonFactory;
import com.google.api.client.json.jackson2.JacksonFactory;
import com.google.api.client.util.store.FileDataStoreFactory;
import com.google.api.services.people.v1.PeopleService;
import com.google.api.services.people.v1.PeopleServiceScopes;
import com.google.api.services.people.v1.model.ListConnectionsResponse;
import com.google.api.services.people.v1.model.Name;
import com.google.api.services.people.v1.model.EmailAddress
import com.google.api.services.people.v1.model.PhoneNumber
import com.google.api.services.people.v1.model.Person;

import org.grails.web.json.JSONObject

import java.io.BufferedReader
import java.io.File
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import java.net.HttpURLConnection
import java.net.URL
import java.net.URLEncoder
import java.security.GeneralSecurityException
import java.util.LinkedHashMap
import java.util.Map

@Secured(['ROLE_USER', 'ROLE_ADMIN', 'IS_AUTHENTICATED_FULLY'])
class GoogleAPIService {

	def grailsApplication

	def crearContacto(String refreshToken, String nombre, String apellido, String email, String telefono) throws IOException, GeneralSecurityException {

		PeopleService service = getPeopleService(refreshToken)
		createContact(service, nombre, apellido, email, telefono)
		return
	}

	def borrarContactosAntiguos(String refreshToken){
		PeopleService service = getPeopleService(refreshToken)
		def results = listConnections(service)
		def cant = 0
		boolean band
		results.connections.each{
			band = false
			cant ++
			while(band != true){
				try{
					deleteContact(service,it.resourceName)
					band = true
				}
				catch(e){
					
				}
			}
		}
		return cant
	}

	public PeopleService getPeopleService(String refreshToken) throws IOException, GeneralSecurityException {

		def jsonFctry = JacksonFactory.getDefaultInstance()

		GoogleClientSecrets clientSecrets = GoogleClientSecrets.load(jsonFctry, new InputStreamReader(new FileInputStream(new File (System.getProperty("user.home") + "/" + grailsApplication.config.getProperty('credencialesGoogle')))))
		// Credential builder

		Credential authorize = new GoogleCredential.Builder().setTransport(GoogleNetHttpTransport.newTrustedTransport())
				.setJsonFactory(jsonFctry)
				.setClientSecrets(clientSecrets.getDetails().getClientId().toString(),
						clientSecrets.getDetails().getClientSecret().toString())
				.build().setAccessToken(getAccessToken(refreshToken)).setRefreshToken(refreshToken); //RefreshToken viene por parametro segun vendedor

		// Create People service
		final NetHttpTransport HTTP_TRANSPORT = GoogleNetHttpTransport.newTrustedTransport();

		PeopleService service = new PeopleService.Builder(HTTP_TRANSPORT, jsonFctry, authorize)
                .setApplicationName("People API Calim")
                .build()

		return service;
	}

	public createContact(PeopleService service, String nombre, String apellido, String telefono, String email){
		Person contactToCreate = new Person()
		List names = new ArrayList<>()
		List phones = new ArrayList<>()
		List emails = new ArrayList<>()
		names.add(new Name().setGivenName(nombre).setFamilyName(apellido))
		phones.add(new PhoneNumber().setValue(telefono))
		emails.add(new EmailAddress().setValue(email))
		contactToCreate.setNames(names)
		contactToCreate.setPhoneNumbers(phones)
		contactToCreate.setEmailAddresses(emails)

		Person createdContact = service.people().createContact(contactToCreate).execute();
		
	}

	public deleteContact(PeopleService service, String resourceName){
		service.people().deleteContact(resourceName).execute()
	}	

	public listConnections(PeopleService service){
		def results = service.people().connections().list("people/me").setPageSize(1500).setPersonFields('names').setSortOrder("LAST_MODIFIED_ASCENDING").execute()
		return results
	}


	private String getAccessToken(String refreshToken) {

		try {
			Map<String, Object> params = new LinkedHashMap<>();
			params.put("grant_type", "refresh_token");
			params.put("client_id", "684311354660-qmrfc2vp3strabcm8s63ulg2ihjpf597.apps.googleusercontent.com")
			params.put("client_secret", "uRa1dE1iqOO1dZSWsmnUtr7A")
			params.put("refresh_token",refreshToken)

			StringBuilder postData = new StringBuilder();
			for (Map.Entry<String, Object> param : params.entrySet()) {
				if (postData.length() != 0) {
					postData.append('&');
				}
				postData.append(URLEncoder.encode(param.getKey(), "UTF-8"));
				postData.append('=');
				postData.append(URLEncoder.encode(String.valueOf(param.getValue()), "UTF-8"));
			}
			byte[] postDataBytes = postData.toString().getBytes("UTF-8");

			URL url = new URL("https://accounts.google.com/o/oauth2/token");
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			con.setDoOutput(true);
			con.setUseCaches(false);
			con.setRequestMethod("POST");
			con.getOutputStream().write(postDataBytes);

			BufferedReader reader = new BufferedReader(new InputStreamReader(con.getInputStream()));
			StringBuffer buffer = new StringBuffer();
			for (String line = reader.readLine(); line != null; line = reader.readLine()) {
				buffer.append(line);
			}

			JSONObject json = new JSONObject(buffer.toString());
			String accessToken = json.getString("access_token");
			return accessToken;
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return null;
	}

}