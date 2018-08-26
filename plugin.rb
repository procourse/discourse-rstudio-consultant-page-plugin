# name: discourse-rstudio
# about: Adds a popup for Discourse that asks users for feedback.
# version: 0.1
# authors: Procourse Team
# url: https://github.com/procourse/procourse-community-feedback

after_initialize do
	add_to_serializer(:group_user, :company) {
		if object.custom_fields
			object.custom_fields['user_field_1']
		end
	}

	add_to_serializer(:group_user, :consult_language) {
		if object.custom_fields
			object.custom_fields['user_field_2']
		end
	}

	add_to_serializer(:group_user, :bio_cooked) {
		if object.user_profile
			object.user_profile.bio_cooked
		end
	}

	class ::User
	  scope :filter_by_username_or_email, ->(filter) do
			user_id = UserCustomField.where('lower(value) ILIKE ? and name IN (?)', "%#{filter}%", ["user_field_1","user_field_2"]).pluck(:user_id).uniq
			if user_id.any?
				return where(id: user_id)
			else
				where('username_lower ILIKE ?', "%#{filter}%")
			end
		end
	end

	# class ::GroupsController
	# 	module DiscourseRStudio
	# 		def members
	# 			group = find_group(:group_id)
	#
	# 			limit = (params[:limit] || 20).to_i
	# 			offset = params[:offset].to_i
	#
	# 			if limit < 0
	# 				raise Discourse::InvalidParameters.new(:limit)
	# 			end
	#
	# 			if offset < 0
	# 				raise Discourse::InvalidParameters.new(:offset)
	# 			end
	#
	# 			dir = (params[:desc] && !params[:desc].blank?) ? 'DESC' : 'ASC'
	# 			order = ""
	#
	# 			if params[:order] && %w{last_posted_at last_seen_at}.include?(params[:order])
	# 				order = "#{params[:order]} #{dir} NULLS LAST"
	# 			end
	#
	# 			users = group.users.human_users
	# 			total = users.count
	#
	# 			if (filter = params[:filter]).present?
	# 				filter = filter.split(',') if filter.include?(',')
	#
	# 				if current_user&.admin
	# 					# users = users.filter_by_username_or_email(filter)
	# 					users = users.filter_by_username_or_company(filter)
	#
	# 				else
	# 					# users = users.filter_by_username(filter)
	# 					users = users.filter_by_username_or_company(filter)
	# 				end
	# 			end
	#
	# 			members = users
	# 				.order('NOT group_users.owner')
	# 				.order(order)
	# 				.order(username_lower: dir)
	# 				.limit(limit)
	# 				.offset(offset)
	#
	# 			owners = users
	# 				.order(order)
	# 				.order(username_lower: dir)
	# 				.where('group_users.owner')
	#
	# 			render json: {
	# 				members: serialize_data(members, GroupUserSerializer),
	# 				owners: serialize_data(owners, GroupUserSerializer),
	# 				meta: {
	# 					total: total,
	# 					limit: limit,
	# 					offset: offset
	# 				}
	# 			}
	# 		end
	# 	end
	# 	prepend DiscourseRStudio
	# end
end
