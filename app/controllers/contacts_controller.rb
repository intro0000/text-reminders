class ContactsController < ApplicationController
    def index
        @contacts = Contact.all.order(:created_at)
        @scheduled_messages = Message.where(status: "scheduled")
        today_start = DateTime.now.in_time_zone(Time.zone).beginning_of_day 
        @delivered_messages_today = Message.where(status: "delivered").where("updated_at > ?", today_start)
    end

    def show
        @contact = Contact.find(params[:id])
    end 

    def new
        @contact = Contact.new
    end

    def create
        @contact = Contact.new(contact_params)

        if @contact.save
            redirect_to @contact
        else
            render :new, status: :unprocessable_entity
        end
    end

    def edit 
        @contact = Contact.find(params[:id])
    end

    def update 
        @contact = Contact.find(params[:id])

        if @contact.update(contact_params)
            redirect_to @contact
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        @contact = Contact.find(params[:id])
        @contact.destroy
    
        redirect_to contacts_path, status: :see_other
    end

    private 

    def contact_params 
        params.require(:contact).permit(:name, :phone_number)
    end
end
