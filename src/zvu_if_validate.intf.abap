INTERFACE zvu_if_validate
  PUBLIC .

  METHODS: validate IMPORTING io_container     TYPE REF TO zvu_cl_prop_container
                              iv_step          TYPE zvu_validation_step
                              is_error_message TYPE zvu_s_message
                    EXPORTING et_message       TYPE bapiret2_tab.

ENDINTERFACE.
