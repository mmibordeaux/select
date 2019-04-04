class Parcoursup
  include Singleton

  URL = 'https://gestion.parcoursup.fr'

  PARTS = [
    'entete',
    'scolarite',
    'activitesCentresInteret',
    'bac',
    'bulletins',
    'ael',
    'lettre-motivation',
    'groupe',
    'documents',
    'formulaire'
  ]

  def candidates
    authenticate
    RestClient.post "#{URL}/Gestion/candidatures.recherche?ACTION=2", {
      g_cn_cod: '',
      g_cn_nom: '',
      g_cn_ine: '',
      g_po_cod: 0,
      g_ea_cod: '',
      g_ea_lib: '',
      g_dp_cod: 0,
      g_py_cod: -1,
      formation: 4331,
      nbResultatsParPage: 50
    },
    {
      cookies: @cookies
    } do |result|
      html = Nokogiri::HTML result.to_s
      html.css(".tableau_resultats tr").each_with_index do |row, index|
        next if index.zero?
        number = row.css('td')[0].text
        # Do something with the value?
      end
    end
  end

  # Ex.: 483982
  def get_dossier_id(candidate_number)
    authenticate
    RestClient.get "#{URL}/DossierCandidat/dossier?ACTION=0&g_cn_cod=#{candidate_number}&g_ti_cod=4331&g_ta_cod=-1&g_gf_cod=-1&c_gp_cod=-1&preferences=recherche&selected=entete&sessionId=#{@cookies['JSESSIONID']}&login=496668&code=0331420P&from=gestion", {
      cookies: @cookie_jar
    } do |result|
      @cookies = result.cookies
      @cookie_jar = result.cookie_jar
      html = Nokogiri::HTML result.to_s
      dossier_id = html.at('input[name=dossierId]')['value']
      puts "Found dossier_id #{dossier_id}"
      return dossier_id
    end
    return
  end

  def load(candidate_number, page)
    authenticate
    dossier_id = get_dossier_id(candidate_number)
    RestClient.get "#{URL}/DossierCandidat/dossier?ACTION=1&module=#{page}&dossierid=#{dossier_id}", {
      cookies: @cookie_jar
    } do |result|
      return result.to_s
    end
  end

  protected

  def authenticate
    RestClient.post "#{URL}/Gestion/authentification", {
      g_ea_cod: ENV['PARCOURSUP_LOGIN'],
      g_ea_mot_pas: ENV['PARCOURSUP_PASSWORD'],
      ACTION: 1
    } do |result|
      @cookies = result.cookies
      @cookie_jar = result.cookie_jar
    end
  end
end