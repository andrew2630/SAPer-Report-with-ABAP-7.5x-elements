*&---------------------------------------------------------------------*
*& Report ZAP_SAPER_PRODUCTS_REPORT_2023
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zap_saper_products_report_2023.

INCLUDE zap_saper_products_r_2023_top.
INCLUDE zap_saper_products_r_2023_s01.
INCLUDE zap_saper_products_r_2023_l01.

START-OF-SELECTION.

*  DATA report TYPE REF TO lcl_saper_products_report_2023.
*  create OBJECT report

*  DATA param_list TYPE zproducts_report_params_list.
*  param_list-categories = s_categ[].
*  param_list-suppliers = s_suppl[].
*  param_list-is_default_colors = p_def.
*  param_list-is_custom_colors = p_cust.
*  param_list-entries_no = p_ent_no.

*  DATA(param_list) = VALUE zproducts_report_params_list(
*    categories = s_categ[]
*    suppliers = s_suppl[]
*    is_default_colors = p_def
*    is_custom_colors = p_cust
*    entries_no = p_ent_no
*  ).

*  DATA(report) = NEW lcl_saper_products_report_2023( param_list ).

*  DATA(report) = NEW lcl_saper_products_report_2023( VALUE #(
*    categories = s_categ[]
*    suppliers = s_suppl[]
*    is_default_colors = p_def
*    is_custom_colors = p_cust
*    entries_no = p_ent_no
*  ) ).
*
*  report->run( ).

  NEW lcl_saper_products_report_2023( VALUE #( categories = s_categ[]
                                               suppliers = s_suppl[]
                                               is_default_colors = p_def
                                               is_custom_colors = p_cust
                                               entries_no = p_ent_no ) )->run( ).
