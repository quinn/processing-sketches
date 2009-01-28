module Capture
  def self.included includer
    includer.class_eval do |includer|
      load_ruby_library "control_panel"
      
      def load_capture_button
        control_panel do |c|
          c.button :save_image_action
        end
        setup_after_button
      end
      
      alias_method :setup_after_button, :setup
      alias_method :setup, :load_capture_button
      
      def save_image_action
        save_frame("screenshots/#{title}-####.png")
      end
    end
  end
end
