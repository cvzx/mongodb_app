# frozen_string_literal: true

class ReservationsController < ApplicationController
  def index
    fetching = reservations_service.list_all

    if fetching.success?
      respond_to do |format|
        format.html {
          render(locals: { reservations: html_presenter.present_collection(fetching.result) })
        }
        format.json {
          render(json: json_presenter.present_collection(fetching.result), status: :ok)
        }
      end
    else
      respond_to do |format|
        format.html
        format.json { render(json: { errors: fetching.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def show
    fetching = reservations_service.find_by_id(params[:id])

    if fetching.success?
      respond_to do |format|
        format.html
        format.json {
          render(json: json_presenter.present(fetching.result), status: :ok)
        }
      end
    else
      respond_to do |format|
        format.html
        format.json { render(json: { errors: fetching.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def create
    creating = reservations_service.create(reservation_params)

    if creating.success?
      respond_to do |format|
        format.html
        format.json { render(json: json_presenter.present(creating.result), status: :ok) }
      end
    else
      respond_to do |format|
        format.html
        format.json { render(json: { errors: creating.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def update
    updating = reservations_service.update(params[:id], reservation_params)

    if updating.success?
      respond_to do |format|
        format.html
        format.json { render(json: json_presenter.present(updating.result), status: :ok) }
      end
    else
      respond_to do |format|
        format.html
        format.json { render(json: { errors: updating.errors }, status: :unprocessable_entity) }
      end
    end
  end

  def destroy
    deleting = reservations_service.delete(params[:id])

    if deleting.success?
      respond_to do |format|
        format.html
        format.json { head(:ok) }
      end
    else
      respond_to do |format|
        format.html
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
