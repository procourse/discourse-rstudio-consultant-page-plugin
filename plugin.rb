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

	# class ::User
	#   scope :filter_by_username_or_email, ->(filter) do
	# 		user_id = UserCustomField.where('lower(value) ILIKE ? and name IN (?)', "%#{filter}%", ["user_field_1","user_field_2"]).pluck(:user_id).uniq
	# 		if user_id.any?
	# 			return where(id: user_id)
	# 		else
	# 			return where('username_lower ILIKE ?', "%#{filter}%")
	# 		end
	# 	end
	# end
end
