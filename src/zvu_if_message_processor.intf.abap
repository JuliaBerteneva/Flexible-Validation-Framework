INTERFACE zvu_if_message_processor
  PUBLIC.
  methods: collect_message,
           release_log returning value(rt_message) type bapiret2_tab.
ENDINTERFACE.
