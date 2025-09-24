INTERFACE zvu_if_check
  PUBLIC.
  METHODS: check IMPORTING io_container TYPE REF TO zvu_cl_prop_container
                           is_error_message type zvu_s_message
                 EXPORTING ev_success   TYPE abap_bool.

ENDINTERFACE.
