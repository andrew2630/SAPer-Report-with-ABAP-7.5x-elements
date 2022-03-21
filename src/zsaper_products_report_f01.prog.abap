*&---------------------------------------------------------------------*
*&  Include           ZSAPER_PRODUCTS_REPORT_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*

FORM start.

  DATA(products_report) = NEW zcl_saper_products_report( VALUE zproducts_report_params_list(
    categories = s_categ[]
    suppliers = s_suppl[]
    is_default_colors = p_def
    is_custom_colors = p_custom
    entries_no = p_ent_no
  ) ).

  products_report->fetch_records( ).

  products_report->display_records( ).

ENDFORM.
