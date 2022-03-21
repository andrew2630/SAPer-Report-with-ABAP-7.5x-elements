*&---------------------------------------------------------------------*
*&  Include           ZSAPER_PRODUCTS_REPORT_S01
*&---------------------------------------------------------------------*

SELECTION-SCREEN BEGIN OF BLOCK selection WITH FRAME TITLE TEXT-s01.
SELECT-OPTIONS s_categ FOR zap_products-category_id.
SELECT-OPTIONS s_suppl FOR zap_products-supplier_id.
SELECTION-SCREEN END OF BLOCK selection.

SELECTION-SCREEN BEGIN OF BLOCK colors WITH FRAME TITLE TEXT-s02.
PARAMETERS p_def RADIOBUTTON GROUP ropt.
PARAMETERS p_custom RADIOBUTTON GROUP ropt.
SELECTION-SCREEN END OF BLOCK colors.

SELECTION-SCREEN BEGIN OF BLOCK restrictions WITH FRAME TITLE TEXT-s03.
PARAMETERS p_ent_no TYPE i DEFAULT 100.
SELECTION-SCREEN END OF BLOCK restrictions.
