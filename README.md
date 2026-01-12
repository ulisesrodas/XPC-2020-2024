# Dashboard: Evolución económica departamenta del Perú (2020-2024)

Este proyecto presenta un análisis exploratorio sobre la recuperación económica de los departamentos del Perú en el periodo post-pandemia. Utilizando microdatos de la **Encuesta Nacional de Hogares (ENAHO)**, se visualizan las tendencias de **Ingreso y Gasto per cápita** en un dashboard desplegado en Shinyapps:

🚀 **[VER DASHBOARD INTERACTIVO:](https://ulisesrodas.shinyapps.io/XPC-2020-2024/)**

## 🔍 Principales Hallazgos
Gracias a la visualización interactiva, se pudieron identificar patrones clave en la recuperación económica:

* **Brecha sierra/selva:** Se evidencia una brecha persistente en departamentos de la Sierra y Selva (como **Puno**, **Loreto** y **Huancavelica**) vs la Costa, cuya recuperación post-pandemia ha sido más lenta en términos monetarios.
* **Tendencia de recuperación:** Al comparar 2020 vs 2024, se observa un repunte generalizado en los ingresos nominales, aunque la capacidad de gasto muestra variaciones heterogéneas según la región.
* * **Caso Madre de Dios:** Es llamativo que esté muy arriba en el ranking. Es un hallazgo interesante que puede estar ligado al auge de la  minería ilegal en la zona. Se necesita más investigación al respecto.

## ℹ️ Fuente de datos (origen)
Los datos brutos fueron obtenidos del portal oficial de **[Microdatos del INEI](https://proyectos.inei.gob.pe/microdatos/index.htm)** siguiendo esta ruta:
1.  **Encuesta:** ENAHO Metodología ACTUALIZADA.
2.  **Selección:** Años 2020, 2022 y 2024 (periodo anual).
3.  **Módulo:** Sumaria (trata de hogares, pero en el script se hizo el tratamiento correspondiente para que esté a nivel de personas).
4.  **Formato:** CSV.

## 🛠️ Tecnologías y herramientas
El flujo de trabajo abarca desde la extracción de datos crudos hasta el despliegue en la nube:

* **Lenguaje:** R (v4.x)
* **ETL & limpieza:** `tidyverse`, `rio`, `stringr`. Procesamiento de módulos *Sumaria* de la ENAHO.
* **Dashboarding:** Quarto (estructura) + Shiny (interactividad Server-side).
* **Visualización:** `plotly` (gráficos dinámicos), `ggplot2`.
* **Despliegue:** ShinyApps.io.

## 📂 Estructura del repositorio
Este repositorio contiene el flujo completo de Data science:

| Archivo | Descripción |
| :--- | :--- |
| `sumaria2020-2022-2024.R` | **Script de procesamiento (ETL):** Carga y consolida los 3 archivos anuales independientes descargados del INEI (2020, 2022, 2024). Se reliza la limpieza, deflactación espacial y cálculo de factores de expansión. |
| `XPC-2020-2024.qmd` | **Código Fuente del dashboard:** Script en Quarto que genera la interfaz visual y la lógica del servidor (Shiny). |
| `CONSOLIDADOXPC_2020_2024.csv` | **Data procesada:** Base de datos final lista para el consumo del dashboard. |

## 👨‍💻 Autor
**Ulises Rodas**
* Sociólogo (UNMSM) & estudiante de Ciencia de datos.
