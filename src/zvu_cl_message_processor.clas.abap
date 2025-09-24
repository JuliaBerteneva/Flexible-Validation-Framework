CLASS zvu_cl_message_processor DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: zvu_if_message_processor.
    ALIASES: collect_message FOR zvu_if_message_processor~collect_message,
             release_log FOR zvu_if_message_processor~release_log.
  PROTECTED SECTION.
    DATA: ms_bapiret2     TYPE bapiret2,
          mt_bapiret2_tab TYPE bapiret2_tab.
  PRIVATE SECTION.
ENDCLASS.



CLASS zvu_cl_message_processor IMPLEMENTATION.
  METHOD collect_message.
    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
      IMPORTING
        syst     = sy
      CHANGING
        bapiret2 = ms_bapiret2.
    IF ms_bapiret2 IS NOT INITIAL.
      APPEND ms_bapiret2 TO mt_bapiret2_tab.
    ENDIF.
    "clear system variable to not collect twice in case of success.
    CLEAR: sy-msgid, sy-msgno, sy-msgty, sy-msgv1, sy-msgv2, sy-msgv3, sy-msgv4.
  ENDMETHOD.

  METHOD release_log.
    rt_message = mt_bapiret2_tab.
  ENDMETHOD.
ENDCLASS.
