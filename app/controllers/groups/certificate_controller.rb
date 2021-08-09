class Groups::CertificateController < ApplicationController
  before_action :set_group
  before_action :set_certificate_group
  before_action :set_certificate, only: [:show]
  before_action do
    require_current_or_admin(@group.core.id)
  end

  def index
    @certificates = @certificate_group.certificates
    respond_to do |format|
       format.pdf {
         render pdf: "relatorio", orientation: "landscape", encoding: "utf-8", margin: {top: 0, bottom: 0, left: 0, right: '0'}
       }
    end
  end

  def show
    respond_to do |format|
       format.pdf {
         render pdf: "relatorio", orientation: "landscape", encoding: "utf-8", margin: {top: 0, bottom: 0, left: 0, right: '0'}
       }
    end
  end

  private

  def set_group
    @group = Group.unscoped.find(params[:group_id])
  end

  def set_certificate_group
    @certificate_group = @group.certificate_groups.find(params[:certificate_group_id])
  end

  def set_certificate
    @certificate = @certificate_group.certificates.find(params[:id])
  end
end
