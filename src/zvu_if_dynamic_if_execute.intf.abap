INTERFACE zvu_if_dynamic_if_execute
  PUBLIC .
  METHODS: execute IMPORTING io_container      TYPE REF TO zvu_cl_prop_container
                             it_rules          TYPE zvu_tt_rules
                             is_error_message type zvu_s_message
                   RETURNING VALUE(rv_success) TYPE abap_bool.
ENDINTERFACE.
