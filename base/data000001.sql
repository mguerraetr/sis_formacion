/********************************************I-DAT-YAC-SIGEFO-0-15/01/2013********************************************/

INSERT INTO segu.tsubsistema ("codigo", "nombre", "fecha_reg", "prefijo", "estado_reg", "nombre_carpeta", "id_subsis_orig")
VALUES   ( E'SIGEFO', E'Sistema de gestión de la formación', E'2017-04-26', E'SIGEFO', E'activo', E'formacion', NULL);

select pxp.f_insert_tgui ('SISTEMA DE GESTIÓN DE LA FORMACIÓN', '', 'SIGEFO', 'si', 1, '', 1, '', '', 'SIGEFO');

/********************************************F-DAT-YAC-SIGEFO-0-15/01/2013********************************************/
/********************************************I-DAT-YAC-SIGEFO-0-05/05/2017********************************************/
select pxp.f_insert_tgui ('Planificación', 'Planificación', 'SIGEFOP', 'si', 1, 'sis_formacion/vista/planificacion/Planificacion.php', 2, '', 'Planificacion', 'SIGEFO');
select pxp.f_insert_tgui ('Competencias', 'Competencias', 'SIGEFOCO', 'si', 2, 'sis_formacion/vista/competencia/Competencia.php', 2, '', 'Competencia', 'SIGEFO');

/********************************************F-DAT-YAC-SIGEFO-0-05/05/2017********************************************/

/********************************************I-DAT-YAC-SIGEFO-1-05/05/2017********************************************/

select param.f_import_tcatalogo_tipo ('insert','tplanificacion_critico','SIGEFO','tplanificacion_critico');
select param.f_import_tcatalogo ('insert','SIGEFO','criterio 01','cri01','tplanificacion_critico');
select param.f_import_tcatalogo ('insert','SIGEFO','criterio 02','cri02','tplanificacion_critico');

select param.f_import_tcatalogo_tipo ('insert','tipocompetencia','SIGEFO','tcompetencia');
select param.f_import_tcatalogo ('insert','SIGEFO','Conocimiento','conocimiento','tipocompetencia');
select param.f_import_tcatalogo ('insert','SIGEFO','Cualidad','cualidad','tipocompetencia');
select param.f_import_tcatalogo ('insert','SIGEFO','Actitud','actitud','tipocompetencia');

/********************************************F-DAT-YAC-SIGEFO-1-05/05/2017********************************************/

/********************************************I-DAT-JUAN-SIGEFO-1-08/05/2017********************************************/

select pxp.f_insert_tgui ('Curso competencia', 'Cursos', 'SIGEFOCU', 'no', 3, 'sis_formacion/vista/curso/FormCursoCompetencia.php', 2, '', 'FormCursoCompetencia', 'SIGEFO');
select pxp.f_insert_tgui ('Curso planificación', 'Curso planificación', 'CUPL', 'no', 4, 'sis_formacion/vista/curso/FormCursoPlanificacion.php', 3, '', 'FormCursoPlanificacion', 'SIGEFO');
select pxp.f_insert_tgui ('Curso funcionario', 'Curso funcionario', 'CUFU', 'no', 5, 'sis_formacion/vista/curso/FormCursoFuncionario.php', 4, '', 'FormCursoFuncionario', 'SIGEFO');

select pxp.f_insert_tgui ('Curso', 'Curso', 'CUR', 'si', 5, 'sis_formacion/vista/curso/Curso.php', 2, '', 'Curso', 'SIGEFO');

select param.f_import_tcatalogo_tipo ('insert','tipo_curso','SIGEFO','tcurso');
select param.f_import_tcatalogo ('insert','SIGEFO','Seminario','tc_seminario','tipo_curso');
select param.f_import_tcatalogo ('insert','SIGEFO','Curso','tc_curso','tipo_curso');


select param.f_import_tcatalogo_tipo ('insert','clasificacion_curso','SIGEFO','tcurso');
select param.f_import_tcatalogo ('insert','SIGEFO','Formación','cc_formacion','clasificacion_curso');
select param.f_import_tcatalogo ('insert','SIGEFO','Capacitación','cc_capacitacion','clasificacion_curso');
select param.f_import_tcatalogo ('insert','SIGEFO','Entrenamiento','cc_entrenamiento','clasificacion_curso');


select param.f_import_tcatalogo_tipo ('insert','origen_curso','SIGEFO','tcurso');
select param.f_import_tcatalogo ('insert','SIGEFO','Externo','oc_externo','origen_curso');
select param.f_import_tcatalogo ('insert','SIGEFO','Interno','oc_interno','origen_curso');

/********************************************F-DAT-JUAN-SIGEFO-1-08/05/2017********************************************/

/********************************************I-DAT-JUAN-SIGEFO-1-16/05/2017********************************************/
select pxp.f_insert_tgui ('SISTEMA DE GESTIÓN DE LA FORMACIÓN', '', 'SIGEFO', 'si', 1, '', 1, '', '', 'SIGEFO');
select pxp.f_insert_tgui ('Cargo competencia', 'Cargo competencia', 'CACO', 'si', 6, 'sis_formacion/vista/competencia/FormCargo.php', 2, '', 'FormCargo', 'SIGEFO');
/********************************************F-DAT-JUAN-SIGEFO-1-16/05/2017********************************************/
/********************************************I-DAT-YAC-SIGEFO-0-17/05/2017********************************************/
select pxp.f_insert_tgui ('Competencias', 'Competencias', 'SIGEFOCO', 'si', 1, 'sis_formacion/vista/competencia/Competencia.php', 2, '', 'Competencia', 'SIGEFO');
select pxp.f_insert_tgui ('Cargo competencia', 'Cargo competencia', 'CACO', 'si', 2, 'sis_formacion/vista/competencia/FormCargo.php', 2, '', 'FormCargo', 'SIGEFO');
select pxp.f_insert_tgui ('Parametrización', 'Parametrización de los datos', 'SIGEFOPAR', 'si', 1, '', 2, '', '', 'SIGEFO');
/********************************************F-DAT-YAC-SIGEFO-0-17/05/2017********************************************/


/********************************************I-DAT-MANU-SIGEFO-0-14/07/2017********************************************/
/* tcatalogo_tipo */

INSERT INTO param.tcatalogo_tipo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_catalogo_tipo", "id_subsistema", "nombre", "tabla", "tabla_estado", "columna_estado")
VALUES 
  (1, NULL, E'2017-06-11 09:09:31.267', NULL, E'activo', NULL, NULL, 36, 29, E'prioridad_curso', E'tcurso', NULL, NULL);
  
/* tcatalogo */

INSERT INTO param.tcatalogo ("id_usuario_reg", "id_usuario_mod", "fecha_reg", "fecha_mod", "estado_reg", "id_usuario_ai", "usuario_ai", "id_catalogo", "codigo", "descripcion", "id_catalogo_tipo", "orden", "icono")
VALUES 
  (1, NULL, E'2017-06-11 09:10:42.841', NULL, E'activo', NULL, NULL, 139, E'pc_alta', E'Alta', 36, NULL, NULL),
  (1, NULL, E'2017-06-11 09:11:11.891', NULL, E'activo', NULL, NULL, 140, E'pc_media', E'Media', 36, NULL, NULL),
  (1, NULL, E'2017-06-11 09:11:30.931', NULL, E'activo', NULL, NULL, 141, E'pc_baja', E'Baja', 36, NULL, NULL);  

/********************************************F-DAT-MANU-SIGEFO-0-14/07/2017********************************************/


