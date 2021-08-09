class DocumentAccessVisualizationsController < ApplicationController
  before_action :require_authentication_for_guest_user
  before_action :set_certificate, only: [:certificate]

  def core
    @cores = Core.order_by_name
  end

  def group
    @core = Core.find(params[:core_id])
    @groups = @core.groups.order_by_name
  end

  def documents_farmers_and_production_unities
    @group = Group.find(params[:group_id])
    @documents = DocumentSended.where(subject: @group)
    @dacs = @group.dac_documents.accepted
    @farmers = @group.farmers
    @production_unities = ProductionUnity.where(group: @group)
  end

  def farmer
    @farmer = Farmer.find(params[:farmer_id])
    @documents = DocumentSended.where(subject: @farmer)
    @certificates = @farmer.certificate_names.where(name_type: ["1", "2", "4"]).order(created_at: :desc)
  end

  def production_unity
    @production_unity = ProductionUnity.find(params[:production_unity_id])
    @documents = DocumentSended.where(subject: @production_unity)
    @certificates = @production_unity.certificate_names.where(name_type: 3).order(created_at: :desc)
  end

  def certificate
    respond_to do |format|
       format.pdf {
         render pdf: "relatorio", template: 'groups/certificate/show',orientation: "landscape", encoding: "utf-8", margin: {top: 0, bottom: 0, left: 0, right: '0'}
       }
    end
  end

  private

  def set_certificate
    @certificate = Certificate.find(params[:certificate_id])
  end
end
