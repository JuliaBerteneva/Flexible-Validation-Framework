*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS lth_herkl_check DEFINITION.
  PUBLIC SECTION.
    INTERFACES: zvu_if_check.
    ALIASES: check FOR zvu_if_check~check.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS lth_herkl_check IMPLEMENTATION.
  METHOD check.
    DATA: ls_bapiret TYPE bapiret2,
          ls_sy      LIKE syst.
    ev_success = abap_false.
    MESSAGE e002(zvu_validator) INTO DATA(lv_message).
*    ls_sy-msgid = sy-msgid.
*    ls_sy-msgty = sy-msgty.
*    ls_sy-msgno = sy-msgno.
*    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
*      EXPORTING
*        syst     = ls_sy
*      CHANGING
*        bapiret2 = ls_bapiret.
*    ls_bapiret-message = lv_message.
*    ls_bapiret-message_v1 = 'HERKL_CHECK'.
*
*    et_message = VALUE #( ( ls_bapiret ) ).
  ENDMETHOD.
ENDCLASS.

CLASS lth_answer DEFINITION.
  PUBLIC SECTION.
    INTERFACES if_abap_testdouble_answer.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.
CLASS lth_answer IMPLEMENTATION.
  METHOD if_abap_testdouble_answer~answer.
    DATA: lo_container TYPE REF TO zvu_cl_prop_container,
          lv_container TYPE REF TO data,
          lt_message   TYPE bapiret2_tab,
          ls_bapiret   TYPE bapiret2.
    FIELD-SYMBOLS: <lo_container> TYPE REF TO zvu_cl_prop_container.

    lv_container = arguments->get_param_importing( 'IO_CONTAINER' ).
    ASSIGN lv_container->* TO <lo_container>.
    "read container and check values
    "...
    result->set_param_returning( value = abap_false ).
*    MESSAGE e002(zvu_validator) INTO DATA(lv_message).
*    CALL FUNCTION 'MAP2I_SYST_TO_BAPIRET2'
*      EXPORTING
*        syst    = sy
*      CHANGING
*        bapirt2 = ls_bapiret.
*
*    lt_message = VALUE #( ( ls_bapiret ) ).
*    result->set_param_exporting( name = 'ET_MESSAGE'
*                                 value = lt_message ).
*    result->set_param_exporting( name = 'EV_SUCCESS'
*                                 value = abap_false ).
  ENDMETHOD.
ENDCLASS.
