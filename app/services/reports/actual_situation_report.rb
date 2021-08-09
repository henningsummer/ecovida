module Reports
  class ActualSituationReport

    def initialize(cores)
      @cores = cores
      @file_name = Rails.root.join('app', 'reports', 'situacao_atual_do_cadastro.odt')
    end

    def process(email)
      report = ODFReport::Report.new(@file_name) do |r|
        r.add_field "RELATORY_DATE", I18n.l(Time.zone.now)

        r.add_section("core", @cores) do |c|
          c.add_field("CORE_NAME") { |core| core.name }

          c.add_section("group", :groups) do |g|
            g.add_field("GROUP_NAME") { |group| group.name }

            g.add_table("group_table", :farmers) do |t|
              t.add_column("CODE", :farmer_code)
              t.add_column("NAME", :name)
              t.add_column("UNID_PRODUTIVA") do |farmer|
                if farmer.production_unity_farmers.any?
                  vinculadas = 0
                  agroindustrias = 0
                  unidade_produtiva = 0

                  farmer.production_unity_farmers.each do |pu|
                    if pu.production_unity.is_agribusiness?
                      agroindustrias += 1
                    else
                      if pu.is_responsible
                        unidade_produtiva += 1
                      else
                        vinculadas += 1
                      end
                    end
                  end

                  text = ""
                  text << "#{vinculadas} vinculadas; " if vinculadas > 0
                  text << "#{agroindustrias} agroindustrias; " if agroindustrias > 0
                  text << "#{unidade_produtiva} cadastradas" if unidade_produtiva > 0
                  text
                else
                  "Não há."
                end
              end

              t.add_column("HAS_PRODUCTS") do |farmer|
                any = false
                farmer.production_unities.each do |pu|
                  any = true if pu.scope_products.any?
                end

                any ? "Cadastrados" : "Não há"
              end

              t.add_column("TERMO") { |farmer| farmer.contract_of_adhesion ? "Sim" : "Não" }
              t.add_column("LAST_DAC") { |farmer| farmer.dac_due_date ? I18n.l(farmer.dac_due_date) : "Não há" }
              t.add_column("CERTIFICATE_DATE") do |farmer|
                dates = []
                farmer.certificate_names.each do |certificate_name|
                  dates << certificate_name.certificate.certificate_group.meeting_date
                end

                dates.any? ? I18n.l(dates.max) : "Não há"
              end
              t.add_column("MAPA") do |farmer|

                if farmer.is_suspended?
                  "Suspenso."
                else
                  if farmer.sig_org_status == 'Atualizado'
                    I18n.l(farmer.sigorgs.last.created_at, format: :only_date)
                  else
                    farmer.sig_org_status
                  end
                end
              end

              globals = global_infos

              r.add_field("TITULAR_COUNT", globals[:farmer_count])
              r.add_field("CERTIFICATE_COUNT", globals[:certificates])
              r.add_field("TOTAL_RECORDS", globals[:mapa_count])
              r.add_field("SUSPENDED", globals[:suspendeds])
            end
          end
        end
      end

      report.generate('tmp/report.odt')

      SendReport.delay.send_report(email, 'Situação atual dos cadastros', 'tmp/report.odt', 'situacao_atual_dos_cadastros')
    end

    handle_asynchronously :process

    private

    def global_infos
      farmer_count = 0
      farmers = []
      mapa_count = 0
      suspendeds = 0

      @cores.each do |core|
        farmer_count += core.farmers.count

        farmers += core.farmers.pluck(:id)
      end

      Farmer.where(id: farmers).each do |farmer|
        mapa_count += 1 if farmer.sig_org_status != "Não adicionado"
        suspendeds += 1 if farmer.is_suspended?
      end

      {
        farmer_count: farmer_count,
        mapa_count: mapa_count,
        certificates: 0,
        suspendeds: suspendeds
      }
    end
  end
end
