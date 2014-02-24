class PagesController < ApplicationController
  def index
    return redirect_to login_users_path if @admin.nil?
    @containers = Container.all
  end

  def docker_create
    name = params[:container][:name]
    repo_url = params[:container][:repo_url]
    redirect_to :back if name.blank?
    redirect_to :back if repo_url.blank?

    Container.docker_create!(name, repo_url)
    render :text => 'ok'
  end

  def docker_kill
    name = params[:container][:name]
    con = Container.find_by_name(name)
    redirect_to :back if con.nil?

    con.delete
    redirect_to :back
  end

  def docker_master_clone
    name = params[:container][:name]
    con = Container.find_by_name(name)
    redirect_to :back if con.nil?
    redirect_to :back unless con.parent.nil?

    con.master_clone
    render :text => 'ok'
  end

  def docker_master_merge
    name = params[:container][:name]
    con = Container.find_by_name(name)
    redirect_to :back if con.nil?
    redirect_to :back if con.parent.nil?

    con.master_merge
    redirect_to :back
  end
end
