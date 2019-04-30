APPS=adafruit_io_http_client freezer_eye
# Can run make Q= to get the max build output
Q := @

.PHONY: compile test $(APPS)

define APP_TEMPLATE
$(1): install_deps_$(1) compile_$(1)

install_deps_$(1):
	$(Q) cd $(1) && mix do deps.clean --unused, deps.get

compile_$(1):
	$(Q) cd $(1) && mix do clean, compile --warnings-as-errors

check_format_$(1):
	$(Q) cd $(1) && mix format --check-formatted

check_unused_deps_$(1):
	$(Q) cd $(1) && mix deps.unlock --unused && git diff --exit-code

test_$(1):
	$(Q) cd $(1) && mix test

dialyzer_$(1):
	$(Q) cd $(1) && mix dialyzer --list-unused-filters --halt-exit-status
endef


$(eval $(call APP_TEMPLATE,adafruit_io_http_client))
$(eval $(call APP_TEMPLATE,freezer_eye))

install_deps: install_deps_adafruit_io_http_client install_deps_freezer_eye
compile: compile_adafruit_io_http_client compile_freezer_eye
test: test_adafruit_io_http_client test_freezer_eye
dialyzer: dialyzer_adafruit_io_http_client dialyzer_freezer_eye
check_format: check_format_adafruit_io_http_client check_format_freezer_eye
check_unused_deps: check_unused_deps_adafruit_io_http_client check_unused_deps_freezer_eye