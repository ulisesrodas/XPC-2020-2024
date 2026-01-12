################################################################################
#### COMPARATIVO DEPARTAMENTAL PERÚ (2020, 2022, 2024) - VERSIÓN OPTIMIZADA ####
################################################################################

# CONFIGURACIÓN INICIAL
setwd("C:/Users/alnil/Escritorio/Mis Documentos/Cursos/Diplomado_PUCP/R/Intermedio")

library(rio)
library(tidyverse)
library(stringr) # Necesario para str_pad
library(forcats) # Necesario para fct_relevel

# ==============================================================================
############# I. DEFINICIÓN DE LA FUNCIÓN "MAESTRA"#############################
# ==============================================================================

procesar_sumaria <- function(año_input) {
  
# 1. IMPORTACIÓN DINÁMICA
# Construimos el nombre del archivo automáticamente: "sumaria" + "2020" + ".csv"
nombre_archivo <- paste0("sumaria", año_input, ".csv")

# Importamos
base <- import(nombre_archivo, encoding = "Latin-1")
  
# 2. SELECCIÓN Y LIMPIEZA
base_clean <- base |>
  select('AÑO', 'UBIGEO', 'DOMINIO', 'ESTRATO',
           'MIEPERHO', 'GASHOG2D', 'INGHOG2D',
           'LINPE', 'LINEA', 'POBREZA', 'FACTOR07', 'LD', 'ESTRSOCIAL') |>
  mutate(
    # DOMINIO -> REGION
    REGION = case_when(
      DOMINIO %in% 1:3 | DOMINIO == 8 ~ "Costa",
      DOMINIO %in% 4:6 ~ "Sierra",
      DOMINIO == 7 ~ "Selva"),
    # ESTRATO -> ZONA
    ZONA = case_when(
      ESTRATO %in% 1:5 ~ "Urbana",
      ESTRATO %in% 6:8 ~ "Rural"),
    # UBIGEO -> DPTO
    UBIGEO = str_pad(as.character(UBIGEO), width = 6, side = "left", pad = "0"),
    COD_DPTO = substr(UBIGEO, 1, 2),
    DPTO = case_when(
      COD_DPTO == "01" ~ "Amazonas",      COD_DPTO == "02" ~ "Áncash",
      COD_DPTO == "03" ~ "Apurímac",      COD_DPTO == "04" ~ "Arequipa",
      COD_DPTO == "05" ~ "Ayacucho",      COD_DPTO == "06" ~ "Cajamarca",
      COD_DPTO == "07" ~ "Callao",        COD_DPTO == "08" ~ "Cusco",
      COD_DPTO == "09" ~ "Huancavelica",  COD_DPTO == "10" ~ "Huánuco",
      COD_DPTO == "11" ~ "Ica",           COD_DPTO == "12" ~ "Junín",
      COD_DPTO == "13" ~ "La Libertad",   COD_DPTO == "14" ~ "Lambayeque",
      COD_DPTO == "15" ~ "Lima",          COD_DPTO == "16" ~ "Loreto",
      COD_DPTO == "17" ~ "Madre de Dios", COD_DPTO == "18" ~ "Moquegua",
      COD_DPTO == "19" ~ "Pasco",         COD_DPTO == "20" ~ "Piura",
      COD_DPTO == "21" ~ "Puno",          COD_DPTO == "22" ~ "San Martín",
      COD_DPTO == "23" ~ "Tacna",         COD_DPTO == "24" ~ "Tumbes",
      COD_DPTO == "25" ~ "Ucayali",       TRUE ~ "Otro"),
    DPTO = fct_relevel(factor(DPTO), sort(unique(DPTO))),
      
    # 3. ESTANDARIZACIÓN Y CÁLCULOS
    FACPOB = FACTOR07 * MIEPERHO,   # Factor poblacional
    FACFW  = round(FACPOB),
    gpc = ((GASHOG2D/12)/MIEPERHO) / LD, # Gasto per cápita mensual deflactado
    ipc = ((INGHOG2D/12)/MIEPERHO) / LD)  # Ingreso per cápita mensual deflactado
  
# 4. RESUMEN (COLLAPSE/SUMMARISE)
resumen_dpto <- base_clean |>
  group_by(DPTO) |>
  summarise(
    AÑO = first(año_input), # Guardamos el año para identificarlo luego
    ingreso_percapita = weighted.mean(ipc, FACPOB, na.rm = TRUE), # Usando FACPOB correcto
    gasto_percapita   = weighted.mean(gpc, FACPOB, na.rm = TRUE), # Usando FACPOB correcto
    .groups = 'drop') |>
  mutate(across(c(gasto_percapita, ingreso_percapita), ~ round(.x, 2)))
  
return(resumen_dpto)
}

# ==============================================================================
############################## II. EJECUCIÓN MASIVA ############################
# ==============================================================================
# Aplicamos la función a la lista de años

# 1. Definimos los años que queremos
año_a_procesar <- c(2020, 2022, 2024)

# 2. Ejecutamos la función para todos y unimos el resultado en UNA sola base
# map_dfr ejecuta la función para cada elemento y une las filas (dfr = data frame row bind)
df_final_consolidado <- map_dfr(año_a_procesar, procesar_sumaria)

# ==============================================================================
############################# III. RESULTADOS ##################################
# ==============================================================================

# Vemos la base consolidada
View(df_final_consolidado)

# Un solo archivo CSV (Recomendado para Shiny):
write.csv(df_final_consolidado, "CONSOLIDADOXPC_2020_2024.csv", row.names = FALSE)

# Si se necesitan los archivos separados, se puede filtrar y guardar:
# write.csv(filter(df_final_consolidado, año == 2020), "DPTO_XPC2020.csv", row.names = FALSE)