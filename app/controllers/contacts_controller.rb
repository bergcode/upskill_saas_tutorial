class ContactsController < ApplicationController.
  
    # GET request to /contact-us
    # Display new contact form
    def new
      @contact = Contact.new
    end
    
    # When a POST request /contacts
    def create
      # Mass assignment of form fields into Contact object
      @contact = Contact.new(contact_params)
      # Save Contact object to database
      if @contact.save
        # Store form fields as parameters, into variables
        name = params[:contact][:name]
        email = params[:contact][:email]
        body = params[:contact][:comments]
        # Place variables into Contact Mailer
        # Email method and send it 
        ContactMailer.contact_email(name, email, body).deliver
        # Store success message into flash hash 
        # Redirect to the new page/ action
        flash[:success]  = "Message sent."
        redirect_to new_contact_path
      else
        # In Contact object doesnt validate
        # store errors in flash hash
        # Redirect to the new page/ action
        flash[:danger] = @contact.errors.full_messages.join(", ")
        redirect_to new_contact_path
      end
    end
    private
    # Use strong paramters and whitelisting to collect data from form fields
      def contact_params
         params.require(:contact).permit(:name, :email, :comments)
      end
end