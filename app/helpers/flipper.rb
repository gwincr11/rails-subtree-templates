require "#{Rails.root}/lib/flipper"

def feature_block(feature_name, &block)
  return unless Flipper::Rails.flipper[feature_name.to_sym].enabled?

  content = capture(&block)
  content_tag :div, content, class: "feature_flag #{feature_name}"
end
