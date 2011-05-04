#!/usr/bin/env ruby

# 2011 David Richards aka oneman

# EZ Lazyhack

lowest_value = 1.0
highest_value = 500.0


require 'gtk2'
require 'xmmsclient'
require 'xmmsclient_glib'

xc = Xmms::Client.new('pitchshifter')

begin
	xc.connect(ENV['XMMS_PATH'])
	rescue Xmms::Client::ClientError
end


xc.add_to_glib_mainloop

window = Gtk::Window.new(Gtk::Window::TOPLEVEL)
window.set_title  "XMMS2 Pitchshifter"
window.border_width = 20
window.signal_connect('delete_event') { Gtk.main_quit }
window.set_size_request(250, -1)
float = Gtk::HScale.new(lowest_value, highest_value, 0.2)
float.value_pos = Gtk::POS_RIGHT
vbox = Gtk::VBox.new(true, 5)
vbox.pack_start(float,   false, true, 0)

res = xc.config_get_value("pitch.pitch")
res.notifier { |notifier| float.value = notifier.to_f }

 
float.signal_connect('value-changed') {

	pitch = float.value.to_s.split(".").first
	xc.config_set_value("pitch.pitch", pitch)

}

window.add(vbox)
window.show_all
Gtk.main
