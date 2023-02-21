# frozen_string_literal: true

class ReservationsController < ApplicationController
  def index
    fetching = reservations_service.list_all

    if fetching.success?
      render json: { reservations: fetching.result }, status: :ok
    else
      render json: { errors: fetching.errors }, status: :unprocessable_entity
    end
  end

  def create
    creating = reservations_service.create

    if creating.success?
      render json: { reservation: creating.result }, status: :ok
    else
      render json: { errors: creating.errors }, status: :unprocessable_entity
    end
  end

  def update
    updating = reservations_service.update

    if updating.success?
      render json: { reservation: updating.result }, status: :ok
    else
      render json: { errors: updating.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    deleting = reservations_service.delete

    if deleting.success?
      head :ok
    else
      render json: { errors: deleting.errors }, status: :unprocessable_entity
    end
  end

  private

  def reservations_service
    ReservationsService.new
  end
end
