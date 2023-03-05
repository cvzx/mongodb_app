# frozen_string_literal: true

class ReservationsController < ApplicationController
  def index
    fetching = reservations_service.list_all

    respond_to do |format|
      if fetching.success?
        format.html { render(locals: { reservations: html_presenter.present(fetching.result) }) }
        format.json { render(json: json_presenter.present(fetching.result), status: :ok) }
      else
        format.html { render(locals: { errors: fetching.errors }) }
        format.json { render(json: { errors: fetching.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def show
    fetching = reservations_service.find_by_id(params[:id])

    respond_to do |format|
      if fetching.success?
        format.html { render(locals: { reservation: html_presenter.present(fetching.result) }) }
        format.json { render(json: json_presenter.present(fetching.result), status: :ok) }
      else
        format.html { render(locals: { errors: fetching.errors }) }
        format.json { render(json: { errors: fetching.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def create
    creating = reservations_service.create(reservation_params)

    respond_to do |format|
      if creating.success?
        format.html { redirect_to(reservation_url(creating.result.id)) }
        format.json { render(json: json_presenter.present(creating.result), status: :ok) }
      else
        flash.now[:alert] = creating.errors
        format.html { render(:new, locals: { params: reservation_params }) }
        format.json { render(json: { errors: creating.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def edit
    finding = reservations_service.find_by_id(params[:id])

    if finding.success?
      render(locals: { reservation: html_presenter.present(finding.result) })
    else
      render(locals: { errors: finding.errors })
    end
  end

  def update
    updating = reservations_service.update(params[:id], reservation_params)

    if updating.success?
      respond_to do |format|
        format.html { redirect_to(reservation_path(params[:id])) }
        format.json { render(json: json_presenter.present(updating.result), status: :ok) }
      end
    else
      respond_to do |format|
        format.html { redirect_to(edit_reservation_path(params[:id]), alert: updating.errors) }
        format.json { render(json: { errors: updating.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    deleting = reservations_service.delete(params[:id])

    respond_to do |format|
      if deleting.success?
        format.html { redirect_to(reservations_path) }
        format.json { head(:ok) }
      else
        format.html { redirect_to(edit_reservation_path(params[:id]), alert: deleting.errors) }
        format.json { render(json: { errors: deleting.errors }, status: :unprocessable_entity) }
      end
    end
  end

  private

  def reservation_params
    params.require(:reservation).permit(
      :hotel_name,
      :price,
      :currency,
      :entry_date,
      :departure_date,
      :guest_name,
      :guest_email,
    ).to_h
  end

  def reservations_service
    ReservationsService.new
  end

  def json_presenter
    JsonReservationPresenter
  end

  def html_presenter
    HtmlReservationPresenter
  end
end
