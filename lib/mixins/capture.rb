module Capture
  def self.included includer
    includer.class_eval do |includer|
      load_ruby_library "control_panel"

      def capture_button
        control_panel do |c|
          c.button :save_image_action
        end
      end
      
      def save_image_action
        raise self.inspect
        save_frame("screenshots/")
      end
    end
  end
end