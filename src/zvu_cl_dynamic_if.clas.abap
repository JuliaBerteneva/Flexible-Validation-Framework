CLASS zvu_cl_dynamic_if DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zvu_if_dynamic_if_execute.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvu_cl_dynamic_if IMPLEMENTATION.
  METHOD zvu_if_dynamic_if_execute~execute.
    "somehow execute check
    "...
    "if check is not passed and msg info is filled
    IF is_error_message IS NOT INITIAL AND rv_success IS INITIAL.
      MESSAGE ID is_error_message-message_id
              TYPE is_error_message-message_type
              NUMBER is_error_message-message_number.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
