module Api
	class WebservicesController < ApplicationController
		respond_to :json,:html
		
	    def login
			password = params["password"].to_s
		    email = params["email"].to_s

			login_res = User.isFound(email,password)

			
				if login_res == true
					result = {
						result:  login_res,
						user: User.find_by_email(email)
					}
				else
					result = {
						result:  login_res	
					}
				end
			
			
			render json: result, status: 200 
		end

	    def cases
			annotation = request.original_url.index('bloodType=') 
			value = request.original_url
			blood_type = value[annotation+10..annotation+12]

			if blood_type.size == 0
				@requests = Request.get_unexpired_requests
			else
				@requests = User.get_myblood_requests(blood_type) 
			end
			
			result = {
				cases:  @requests
			}
			
			render json: result, status: 200 
		end

	    def donate
			user_id = params["userid"].to_i
		    request_id = params["caseid"].to_i
			
			
			error_message = ""
			if !User.exists?(user_id)
				result = false
			elsif !Request.exists?(request_id)
				result = false
			else
				@active_request = ActiveRequest.new
			    @active_request.donor_id = user_id
			    @active_request.request_id = request_id

			    current_user = User.find(user_id)

			    if ActiveRequest.check_donations_status(user_id,request_id) && 
			      !current_user.pause && current_user.able_to_donate? && current_user.can_donate
			     
			      if @active_request.save 
			        result = true
			      end
			    
			    elsif current_user.pause
			    	result = false
			        error_message = "Your account paused, unpause your account to donate" 
			    elsif !current_user.can_donate
			    	result = false
			        error_message = "Your account paused, call us to solve the problem" 
			    elsif !current_user.able_to_donate?
			    	result = false
			        error_message = "You can not donate, you should donate after 3 monthes from the last donation " 
			    else
			    	result = false
			        error_message = "You are donated before"
			    end 
			end

			result = {
				result:  result,
				error_message: error_message
			}
			
			render json: result, status: 200 
		end

		def newdonor 
			annotation = request.original_url.index('blood_type=') 
			value = request.original_url
			blood_type = value[annotation+11..annotation+13]

			if blood_type[1] == '+' || blood_type[1] == '-'
				blood_type = blood_type[0..1]
			else
				blood_type = blood_type[0..2]
			end


			@user = User.new
		    @user.name = params["name"].to_s
		    @user.email = params["email"].to_s
		    @user.phone = params["phone"].to_s
		    @user.nationalid = params["nationalid"].to_s
		    @user.blood_type = blood_type
		    @user.location_name = params["location_name"].to_s
		    @user.location_lat = params["location_lat"].to_f
		    @user.location_lng = params["location_lng"].to_f
		    @user.gender = params["gender"].to_s
		    @user.birth_date = params["birth_date"]
		    @user.created_at = Time.now.strftime("%Y-%m-%d")
		    @user.lastdonation = params["lastdonation"]
		    @user.password = params["password"].to_s
		    @user.num_of_active_requests = 0
 			@user.savedpeople = 0
  			@user.notifications = 0

			error_message = ""

		    if !User.where(:email => @user.email).blank?
		      result = false
		      error_message += 'Email already used by another donor | '
		    end

		    if !User.where(:phone => @user.phone).blank?
		      result = false
		      error_message += 'Phone number already used by another donor | '
		    end

		    if !User.where(:nationalid => @user.nationalid).blank?
		      result = false
		      error_message += 'National id already used by another donor | '
		    end

		    if @user.save
		      result = true
		    else
		      result = false
		    end  

			result = {
				result:  result,
				error_message: error_message
			}
			
			render json: result, status: 200 
		end

		def newcase
			annotation = request.original_url.index('blood_type=') 
			value = request.original_url
			blood_type = value[annotation+11..annotation+13]

			if blood_type[1] == '+' || blood_type[1] == '-'
				blood_type = blood_type[0..1]
			else
				blood_type = blood_type[0..2]
			end

			@request = Request.new
		    @request.contact_name = params["name"].to_s
		    @request.contact_email = params["email"].to_s
		    @request.contact_phone = params["phone"].to_s
		    @request.contact_nationalid = params["nationalid"].to_s
		    @request.blood_type = blood_type
		    @request.bloodbag = params["bloodbag"].to_i
		    @request.patient_name = params["patient_name"].to_s
		    @request.expiredate = params["expiredate"].to_s
		    @request.hospital_location_lng = params["hospital_location_lng"].to_f
		    @request.hospital_location_lat = params["hospital_location_lat"].to_f
		    @request.hospital_location = params["hospital_location"].to_s
		    @request.hospital_name = params["hospital_name"].to_s
		    @request.created_at = Time.now.strftime("%Y-%m-%d")
		    @request.num_of_donors = 0

			error_message = ""

		    if @request.save
		      result = true
		    else
		      result = false
		    end  

			result = {
				result:  result,
				error_message: error_message
			}
			
			render json: result, status: 200 
		end


		def editdonor 
			annotation = request.original_url.index('blood_type=') 
			value = request.original_url
			blood_type = value[annotation+11..annotation+13]

			if blood_type[1] == '+' || blood_type[1] == '-'
				blood_type = blood_type[0..1]
			else
				blood_type = blood_type[0..2]
			end


			@user = User.new
			id = params["id"].to_i
		    @user.name = params["name"].to_s
		    @user.email = params["email"].to_s
		    @user.phone = params["phone"].to_s
		    @user.nationalid = params["nationalid"].to_s
		    @user.blood_type = blood_type
		    @user.location_name = params["location_name"].to_s
		    @user.location_lat = params["location_lat"].to_f
		    @user.location_lng = params["location_lng"].to_f
		    @user.gender = params["gender"].to_s
		    @user.birth_date = params["birth_date"]
		    @user.lastdonation = params["lastdonation"]
		    @user.password = params["password"].to_s
		
			error_message = ""
			result = true
			@tmp_user = User.find(id)

		    if @tmp_user.email != @user.email && !User.where(:email => @user.email).blank?
		      result = false
		      error_message += 'Email already used by another donor | '
		    end

		    if @tmp_user.phone != @user.phone && !User.where(:phone => @user.phone).blank?
		      result = false
		      error_message += 'Phone number already used by another donor | '
		    end

		    if @tmp_user.nationalid != @user.nationalid && !User.where(:nationalid => @user.nationalid).blank?
		      result = false
		      error_message += 'National id already used by another donor | '
		    end

			@user = User.find(id)
			@user.update_attribute(:name , @user.name)
			@user.update_attribute(:email , @user.email)
			@user.update_attribute(:phone , @user.phone)
			@user.update_attribute(:location_name , @user.location_name)
			@user.update_attribute(:blood_type , blood_type)
			@user.update_attribute( :nationalid , @user.nationalid)
			@user.update_attribute(:location_lat , @user.location_lat)
			@user.update_attribute(:location_lng , @user.location_lng)
			@user.update_attribute(:birth_date , @user.birth_date)
			@user.update_attribute(:gender , @user.gender)
			@user.update_attribute(:lastdonation , @user.lastdonation)
			@user.update_attribute(:password , @user.password)
		    
		    
			result = {
				result:  result,
				error_message: error_message
			}
			
			render json: result, status: 200 
		end
	end
end

