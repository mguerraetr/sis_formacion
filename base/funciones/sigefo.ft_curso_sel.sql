CREATE OR REPLACE FUNCTION sigefo.ft_curso_sel (
  p_administrador integer,
  p_id_usuario integer,
  p_tabla varchar,
  p_transaccion varchar
)
RETURNS varchar AS
$body$
/**************************************************************************
 SISTEMA:		Sistema de gestión de la formación
 FUNCION: 		sigefo.ft_curso_sel
 DESCRIPCION:   Funcion que devuelve conjuntos de registros de las consultas relacionadas con la tabla 'sigefo.tcurso'
 AUTOR: 		 (admin)
 FECHA:	        22-01-2017 15:35:03
 COMENTARIOS:	
***************************************************************************
 HISTORIAL DE MODIFICACIONES:

 DESCRIPCION:	
 AUTOR:			
 FECHA:		
***************************************************************************/

DECLARE

  v_var            VARCHAR ;	
  v_count          INTEGER;	
  v_consulta       VARCHAR;
  v_consultaTemp   VARCHAR;
  v_consultaInsert VARCHAR;
  v_parametros     RECORD;
  v_nombre_funcion TEXT;
  v_resp           VARCHAR;
  item             RECORD;
  item1             RECORD;
  v_aux            VARCHAR;
BEGIN

  v_nombre_funcion = 'sigefo.ft_curso_sel';
  v_parametros = pxp.f_get_record(p_tabla);
	
  /*********************************
   #TRANSACCION:  'SIGEFO_SCU_SEL'
   #DESCRIPCION:	Consulta de datos
   #AUTOR:		admin
   #FECHA:		22-01-2017 15:35:03
  ***********************************/

  	IF (p_transaccion = 'SIGEFO_SCU_SEL')
		THEN
          BEGIN 
              v_consulta:='SELECT 
                          scu.id_curso,
                          scu.id_gestion,
                          scu.id_lugar,
                          scu.id_lugar_pais,
                          scu.id_proveedor,
                          scu.origen,
                          scu.fecha_inicio,
                          scu.objetivo,
                          scu.estado_reg,
                          scu.cod_tipo,
                          scu.cod_prioridad,
                          scu.horas,
                          scu.nombre_curso,
                          scu.cod_clasificacion,
                          scu.expositor,
                          scu.contenido,
                          scu.fecha_fin,
                          scu.fecha_reg,
                          scu.usuario_ai,
                          scu.id_usuario_reg,
                          scu.id_usuario_ai,
                          scu.id_usuario_mod,
                          scu.fecha_mod,
                          scu.evaluacion,
                          scu.certificacion,
                          g.gestion AS gestion,

                          (SELECT lp.nombre
                          FROM param.tlugar lp
                          WHERE lp.id_lugar=scu.id_lugar_pais ) :: VARCHAR  AS nombre_pais,

                          (SELECT lp.nombre
                          FROM param.tlugar lp
                          WHERE lp.id_lugar=scu.id_lugar ) :: VARCHAR  AS nombre,

                          (SELECT p.desc_proveedor
                          FROM param.vproveedor p
                          WHERE p.id_proveedor=scu.id_proveedor ) :: VARCHAR  AS desc_proveedor,

                          (SELECT usu1.cuenta
                          FROM segu.tusuario usu1
                          WHERE usu1.id_usuario =scu.id_usuario_reg )  :: VARCHAR  AS usr_reg, 

                          (SELECT usu2.cuenta
                          FROM segu.tusuario usu2
                          WHERE usu2.id_usuario =scu.id_usuario_mod )  :: VARCHAR  AS usr_mod, 

                          (SELECT array_to_string( array_agg( cc.id_competencia), '','' ) 
                          FROM sigefo.tcurso_competencia cc 
                          JOIN sigefo.tcurso c ON c.id_curso=cc.id_curso 
                          WHERE cc.id_curso=scu.id_curso)::VARCHAR AS id_competencias,
                                                                                                                                  
                          (SELECT array_to_string( array_agg( co.competencia), ''<br>'' ) 
                          FROM sigefo.tcurso_competencia cc 
                          JOIN sigefo.tcurso c ON c.id_curso=cc.id_curso 
                          JOIN sigefo.tcompetencia co ON co.id_competencia=cc.id_competencia
                          WHERE cc.id_curso=scu.id_curso)::VARCHAR AS competencias,

                          (SELECT array_to_string( array_agg( cp.id_planificacion), '','' ) 
                          FROM sigefo.tcurso_planificacion cp 
                          JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso 
                          WHERE cp.id_curso=scu.id_curso)::VARCHAR AS id_planificaciones,
                                                                                                                                  
                          (SELECT array_to_string( array_agg( pl.nombre_planificacion),''<br>'' ) 
                          FROM sigefo.tcurso_planificacion cp 
                          JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso 
                          JOIN sigefo.tplanificacion pl ON pl.id_planificacion=cp.id_planificacion
                          WHERE cp.id_curso=scu.id_curso)::VARCHAR AS planificaciones,

                          (SELECT array_to_string( array_agg( cf.id_funcionario), '','' ) 
                          FROM sigefo.tcurso_funcionario cf 
                          JOIN sigefo.tcurso c ON c.id_curso=cf.id_curso 
                          WHERE cf.id_curso=scu.id_curso)::VARCHAR AS id_funcionarios,
                                                                                                                                  
                          (SELECT array_to_string( array_agg(PERSON.nombre_completo2), ''<br>'' ) 
                          FROM sigefo.tcurso_funcionario cf 
                          JOIN sigefo.tcurso c ON c.id_curso=cf.id_curso 
                          JOIN orga.tfuncionario FUNCIO ON FUNCIO.id_funcionario=cf.id_funcionario
                          JOIN SEGU.vpersona PERSON ON PERSON.id_persona=FUNCIO.id_persona                                                   
                          WHERE cf.id_curso=scu.id_curso)::VARCHAR AS funcionarios

                          FROM sigefo.tcurso scu
                          JOIN param.tgestion g ON g.id_gestion=scu.id_gestion         
                          
                          ';

              RETURN v_consulta;
          END;

    /*********************************
     #TRANSACCION:  'SIGEFO_SCU_CONT'
     #DESCRIPCION:	Conteo de registros
     #AUTOR:		admin
     #FECHA:		22-01-2017 15:35:03
    ***********************************/

	ELSIF (p_transaccion = 'SIGEFO_SCU_CONT')
    	THEN
      		BEGIN
        		v_consulta:='select count(id_curso)
					    from sigefo.tcurso scu
					    inner join segu.tusuario usu1 on usu1.id_usuario = scu.id_usuario_reg
						left join segu.tusuario usu2 on usu2.id_usuario = scu.id_usuario_mod
					    where ';
                v_consulta:=v_consulta || v_parametros.filtro;
                RETURN v_consulta;
            END;
            
    /*********************************
    #TRANSACCION:  'PM_LUG_SEL'
    #DESCRIPCION:	Consulta de datos
    #AUTOR:		rac
    #FECHA:		29-08-2011 09:19:28
    ***********************************/

    ELSEIF (p_transaccion = 'PM_PAISLUGAR_SEL')
    	THEN
			BEGIN
        		v_consulta:='select
                            lug.id_lugar,
                            lug.nombre,
                            lug.tipo
                          	FROM param.tlugar lugp LEFT JOIN param.tlugar lug ON lugp.id_lugar = lug.id_lugar_fk
							where';

                v_consulta:=v_consulta || v_parametros.filtro;
                v_consulta:=
                v_consulta || ' order by ' || v_parametros.ordenacion || ' ' || v_parametros.dir_ordenacion || ' limit ' ||
                v_parametros.cantidad || ' offset ' || v_parametros.puntero;
        		RETURN v_consulta;
      		END;        
            
    /*********************************
    #TRANSACCION:  'PM_LUG_CONT'
    #DESCRIPCION:	Conteo de registros
    #AUTOR:		rac
    #FECHA:		29-08-2011 09:19:28
    ***********************************/

    ELSIF (p_transaccion = 'PM_PAISLUGAR_CONT')
    	THEN
    		BEGIN
    			v_consulta:='select count(lug.id_lugar)
                            FROM param.tlugar lugp LEFT JOIN param.tlugar lug ON lugp.id_lugar = lug.id_lugar_fk
    						where ';
    			v_consulta:=v_consulta || v_parametros.filtro;
		    	RETURN v_consulta;  
    		END;
            
    /*********************************
    #TRANSACCION:  'SIGEFO_LCURSO_CONT'
    #DESCRIPCION:	Conteo de registros
    #AUTOR:		rac
    #FECHA:		29-08-2011 09:19:28
    ***********************************/

    ELSIF (p_transaccion = 'SIGEFO_LCURSO_CONT')
    	THEN
    		BEGIN
    			v_consulta:='SELECT COUNT(t.id_uo)                                  
                            FROM orga.tuo t
                            INNER JOIN sigefo.tplanificacion_uo tp ON tp.id_uo = t.id_uo
                            INNER JOIN sigefo.tplanificacion p ON p.id_planificacion = tp.id_planificacion
                            INNER JOIN sigefo.tcurso_planificacion cp ON cp.id_planificacion = p.id_planificacion
                            INNER JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso
                            INNER JOIN sigefo.tcurso_funcionario cf ON cf.id_curso=c.id_curso                                                                                      
                            WHERE t.estado_reg=''activo''                                                                                                                                                                       
                            GROUP BY t.id_uo,t.nombre_unidad,c.id_curso,c.nombre_curso,c.cod_prioridad,p.id_planificacion,cf.id_curso';    		
		    	RETURN v_consulta;  
    		END;        
            
    /*********************************
    #TRANSACCION:  'SIGEFO_LCURSO_SEL'
    #DESCRIPCION:	Seleccion de datos de arbol
    #AUTOR:		manu
    #FECHA:		29-08-2011 09:19:28
    ***********************************/

    ELSIF (p_transaccion = 'SIGEFO_LCURSO_SEL')
    	THEN
        	BEGIN
            	v_consultaTemp ='CREATE TEMP TABLE ttemporal
                          		(
                                  id_correlativo SERIAL,                                                                    
                                  id_uo_t_temp INTEGER,
                                  id_uo_padre_temp INTEGER,
                                  id_uo_temp INTEGER,                                  
                                  nombre_unidad_temp VARCHAR,
                                  id_curso_temp INTEGER,
                                  nombre_curso_temp VARCHAR,
                                  cod_prioridad_temp VARCHAR,
                                  tipo_nodo_temp VARCHAR,
                                  id_correlativo_key INTEGER,
                                  horas_temp INTEGER,
                                  cantidad_temp INTEGER
                                )';                                                                                                                     
				EXECUTE (v_consultaTemp);                                                          
                              v_count = 0;          	
                              FOR item in  
                              (
                                  SELECT
                                  DISTINCT
                                  CASE
                                      WHEN (c.id_curso is not null)
                                          THEN t.id_uo :: INTEGER
                                  ELSE
                                      0 :: INTEGER
                                  END AS id_uo_t,
                                  CASE
                                      WHEN (c.id_curso is null)
                                          THEN t.id_uo :: INTEGER
                                  ELSE
                                      0 ::INTEGER
                                  END AS id_uo_padre,
                             	  t.id_uo,
                                  t.nombre_unidad,
                                  0 :: INTEGER AS id_curso,
                                  0 :: VARCHAR AS nombre_curso,
                                  0 :: VARCHAR AS cod_prioridad,
                                  CASE
                                      WHEN (t.id_uo is not  null)
                                          THEN 'raiz'::VARCHAR
                                  END AS tipo_nodo
                                  
                                  FROM orga.tuo t 
                                  INNER JOIN sigefo.tplanificacion_uo tp ON tp.id_uo = t.id_uo
                                  INNER JOIN sigefo.tplanificacion p ON p.id_planificacion = tp.id_planificacion
                                  INNER JOIN sigefo.tcurso_planificacion cp ON cp.id_planificacion = p.id_planificacion
                                  INNER JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso
                                  INNER JOIN sigefo.tcurso_funcionario cf ON cf.id_curso=c.id_curso                                               
                                  WHERE t.estado_reg='activo'  
                                  GROUP BY t.id_uo,t.nombre_unidad,c.id_curso,c.nombre_curso,c.cod_prioridad,p.id_planificacion,cf.id_curso
                                                                                                                  
                                  UNION ALL
                                                                                                                                                                    
                                  SELECT 
                                  DISTINCT
                                  CASE
                                    WHEN (c.id_curso is null)
                                      THEN t.id_uo :: INTEGER
                                    ELSE
                                      0 :: INTEGER
                                  END AS id_uo_t,
                                  CASE
                                      WHEN (c.id_curso is not null)
                                          THEN t.id_uo :: INTEGER
                                  ELSE
                                      0 :: INTEGER
                                  END AS id_uo_padre,
                                  t.id_uo,
                                  t.nombre_unidad,
                                  c.id_curso,
                                  c.nombre_curso :: VARCHAR,
                                  c.cod_prioridad :: VARCHAR,                                            
                                  CASE
                                      WHEN (c.id_curso is not  null)
                                          THEN 'hijo'::varchar
                                  END AS tipo_nodo
                                       
                                  FROM orga.tuo t
                                  INNER JOIN sigefo.tplanificacion_uo tp ON tp.id_uo = t.id_uo
                                  INNER JOIN sigefo.tplanificacion p ON p.id_planificacion = tp.id_planificacion
                                  INNER JOIN sigefo.tcurso_planificacion cp ON cp.id_planificacion = p.id_planificacion
                                  INNER JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso
                                  INNER JOIN sigefo.tcurso_funcionario cf ON cf.id_curso=c.id_curso  
                                  --id_gestion colocar--                                                                                   
                                  WHERE t.estado_reg='activo' AND c.id_gestion=15                                                                                                                                                                       
                                  GROUP BY t.id_uo,t.nombre_unidad,c.id_curso,c.nombre_curso,c.cod_prioridad,p.id_planificacion,cf.id_curso
                                  ORDER BY id_uo,tipo_nodo DESC    
                              )LOOP
                                                            
                              v_aux:='';
                              v_count := v_count -1;
                                               
                              v_aux:= v_aux||'insert into ttemporal(
                              								id_uo_t_temp,
                              								id_uo_padre_temp,
                                                            id_uo_temp,
                         	                                nombre_unidad_temp,
                                                            id_curso_temp,
                                                            nombre_curso_temp,
                                                            cod_prioridad_temp,
                                                            tipo_nodo_temp,
                                                            id_correlativo_key 
                                                            ) 
                              						values (';  
                              v_aux := v_aux || item.id_uo_t||',';                                                                                          
                              v_aux := v_aux || item.id_uo_padre||',';                              
                              v_aux := v_aux || item.id_uo||',';
                              --SE CREO UN ARTIFICIO PARA MOSTRAR PADRE-HIJO
                              IF(item.id_uo_t = 0)
                              	THEN 
                                     v_aux := v_aux || ''''|| '>>> ' || item.nombre_curso ||''',';  
                                ELSE
                                	 v_aux := v_aux || ''''|| item.nombre_unidad ||''',';      
                              END IF;                             
                                       	                                                                                
                              v_aux := v_aux || item.id_curso||',';                                                            
                              v_aux := v_aux || ''''|| item.nombre_curso||''','; 
                              
                              IF(item.cod_prioridad = '0')
                              	THEN 
                                     v_aux := v_aux || ''''|| '-' ||''','; 
                                ELSE                               
                                	 v_aux := v_aux || ''''|| item.cod_prioridad ||''',';      
                              END IF;                                  
                              
                              v_aux := v_aux || ''''||item.tipo_nodo||''',';                                     
                              
                              IF(item.id_uo_t = 0)
                              	THEN 
                                     v_aux := v_aux || v_count||')'; 
                                ELSE
                                	 v_aux := v_aux || item.id_uo_t||')';     
                              END IF;
                              EXECUTE(v_aux);                                                                                                            
                                                                                                                                                                  
                          END LOOP;                              
						  	                                               		                          
                          v_consulta:='SELECT 
                                       id_correlativo,
                                       id_uo_t_temp,	
                                       id_uo_padre_temp, 
                                       id_uo_temp,
                                       nombre_unidad_temp, 
                                       id_curso_temp, 
                                       nombre_curso_temp, 
                                       cod_prioridad_temp,
                                       tipo_nodo_temp,
                                       id_correlativo_key
                                       FROM ttemporal';
                                                  
                          /*for item1 in(SELECT 
                                       id_correlativo,
                                       id_uo_t_temp,	
                                       id_uo_padre_temp, 
                                       id_uo_temp,
                                       nombre_unidad_temp, 
                                       id_curso_temp, 
                                       nombre_curso_temp, 
                                       cod_prioridad_temp,
                                       tipo_nodo_temp,
                                       id_correlativo_key
                                       FROM ttemporal)loop
                          raise exception '%',item1.nombre_curso_temp;            
                          end loop;   */                          	                                                                                             
                RETURN v_consulta;       	
		    END;   	      
                         
    /*********************************
    #TRANSACCION:  'SIGEFO_SCU_ARB_SEL'
    #DESCRIPCION:	Seleccion de datos
    #AUTOR:		manu
    #FECHA:		03-07-2017 09:19:28
    ***********************************/
	
  	ELSEIF (p_transaccion = 'SIGEFO_SCU_ARB_SEL')
    	THEN
        	BEGIN
            	v_consultaTemp ='CREATE TEMP TABLE ttemporal
                          		(
                                  id_correlativo SERIAL,                                                                    
                                  id_uo_t_temp INTEGER,
                                  id_uo_padre_temp INTEGER,
                                  id_uo_temp INTEGER,                                  
                                  nombre_unidad_temp VARCHAR,
                                  id_curso_temp INTEGER,
                                  nombre_curso_temp VARCHAR,
                                  cod_prioridad_temp VARCHAR,
                                  tipo_nodo_temp VARCHAR,
                                  id_correlativo_key INTEGER,
                                  horas_temp INTEGER,
                                  cantidad_temp INTEGER
                                )';                                                                                                                     
				EXECUTE (v_consultaTemp);                                                          
                      IF (v_parametros.id_gestion :: INTEGER >= 0) 
                          THEN  
                              v_count = 0;          	
                              FOR item in  
                              (
                                  SELECT
                                  DISTINCT
                                  CASE
                                      WHEN (c.id_curso is not null)
                                          THEN t.id_uo :: INTEGER
                                  ELSE
                                      0 :: INTEGER
                                  END AS id_uo_t,
                                  CASE
                                      WHEN (c.id_curso is null)
                                          THEN t.id_uo :: INTEGER
                                  ELSE
                                      0 ::INTEGER
                                  END AS id_uo_padre,
                             	  t.id_uo,
                                  t.nombre_unidad,
                                  0 :: INTEGER AS id_curso,
                                  0 :: VARCHAR AS nombre_curso,
                                  'vacio' :: VARCHAR AS cod_prioridad,
                                  CASE
                                      WHEN (t.id_uo is not  null)
                                          THEN 'raiz'::VARCHAR
                                  END AS tipo_nodo,
                                  0 :: INTEGER as horas,
                                  0 :: INTEGER AS cantidad
                                  
                                  FROM orga.tuo t 
                                  INNER JOIN sigefo.tplanificacion_uo tp ON tp.id_uo = t.id_uo
                                  INNER JOIN sigefo.tplanificacion p ON p.id_planificacion = tp.id_planificacion
                                  INNER JOIN sigefo.tcurso_planificacion cp ON cp.id_planificacion = p.id_planificacion
                                  INNER JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso
                                  INNER JOIN sigefo.tcurso_funcionario cf ON cf.id_curso=c.id_curso   
                                  WHERE t.estado_reg='activo'                                              
                                  GROUP BY t.id_uo,t.nombre_unidad,c.id_curso,c.nombre_curso,c.cod_prioridad,p.id_planificacion,cf.id_curso
                                                                                                                  
                                  UNION ALL
                                                                                                                                                                    
                                  SELECT 
                                  DISTINCT
                                  CASE
                                    WHEN (c.id_curso is null )
                                      THEN t.id_uo :: INTEGER
                                    ELSE
                                      0 :: INTEGER
                                  END AS id_uo_t,
                                  CASE
                                      WHEN (c.id_curso is not null)
                                          THEN t.id_uo :: INTEGER
                                  ELSE
                                      0 :: INTEGER
                                  END AS id_uo_padre,
                                  t.id_uo,
                                  t.nombre_unidad,
                                  c.id_curso,
                                  c.nombre_curso :: VARCHAR,
                                  c.cod_prioridad :: VARCHAR,                                            
                                  CASE
                                      WHEN (c.id_curso is not  null)
                                          THEN 'hijo'::varchar
                                  END AS tipo_nodo,
                                  c.horas :: INTEGER,
                                  count (cf.id_curso) AS cantidad
                                  
                                  FROM orga.tuo t
                                  INNER JOIN sigefo.tplanificacion_uo tp ON tp.id_uo = t.id_uo
                                  INNER JOIN sigefo.tplanificacion p ON p.id_planificacion = tp.id_planificacion
                                  INNER JOIN sigefo.tcurso_planificacion cp ON cp.id_planificacion = p.id_planificacion
                                  INNER JOIN sigefo.tcurso c ON c.id_curso=cp.id_curso
                                  INNER JOIN sigefo.tcurso_funcionario cf ON cf.id_curso=c.id_curso                                                                                      
                                  WHERE c.id_gestion = v_parametros.id_gestion AND t.estado_reg='activo'                                                                                                                                                                        
                                  GROUP BY t.id_uo,t.nombre_unidad,c.id_curso,c.nombre_curso,c.cod_prioridad,p.id_planificacion,cf.id_curso
                                  ORDER BY id_uo,tipo_nodo DESC    
                              )LOOP
                                                            
                              v_aux:='';
                              v_count := v_count -1;

                              v_aux:= v_aux||'insert into ttemporal(
                              								id_uo_t_temp,
                              								id_uo_padre_temp,
                                                            id_uo_temp,
                                                            nombre_unidad_temp,
                                                            id_curso_temp,
                                                            nombre_curso_temp,
                                                            cod_prioridad_temp,
                                                            tipo_nodo_temp,
                                                            id_correlativo_key,
                                                            horas_temp,
                                                            cantidad_temp 
                                                            ) 
                              						values (';  
                              v_aux := v_aux || item.id_uo_t||',';                                                                                          
                              v_aux := v_aux || item.id_uo_padre||',';                              
                              v_aux := v_aux || item.id_uo||',';
                          	  --SE CREO UN ARTIFICIO PARA MOSTRAR PADRE-HIJO
                              IF(item.id_uo_t = 0)
                              	THEN 
                                     v_aux := v_aux || ''''|| item.nombre_curso ||''',';  
                                ELSE
                                	 v_aux := v_aux || ''''|| item.nombre_unidad ||''',';      
                              END IF;
     						  v_aux := v_aux || item.id_curso||',';
                              v_aux := v_aux || ''''|| item.nombre_curso ||''','; 
                              
                              IF(item.cod_prioridad = 'vacio')
                              	THEN                                 
									v_aux := v_aux || ''''|| '-' ||''',';
                                ELSE                              
                                	v_aux := v_aux || ''''|| item.cod_prioridad||''',';     
                              END IF; 
                              
                              v_aux := v_aux || ''''|| item.tipo_nodo||''','; 
                              
                              IF(item.id_uo_t = 0)
                              	THEN 
                                     v_aux := v_aux || v_count||','; 
                                ELSE
                                	 v_aux := v_aux || item.id_uo_t||','; 
                              END IF;   
                              
                              v_aux := v_aux || item.horas||','; 
                              v_aux := v_aux || item.cantidad||')';
                              EXECUTE(v_aux);                                                                                                            
                                                                                                                                                                  
                          END LOOP;                              
						  	
                          v_consultaTemp :='';
                          IF v_parametros.id_padre = '%'
                          THEN
                              v_consultaTemp:=v_consultaTemp || 'id_uo_padre_temp = 0';                           
                          ELSE
                              v_consultaTemp:=v_consultaTemp || 'id_uo_padre_temp ='|| v_parametros.id_padre;                              
                          END IF;
                       		                          
                          v_consulta:='SELECT 
                                       id_correlativo,
                                       id_uo_t_temp,	
                                       id_uo_padre_temp, 
                                       id_uo_temp,
                                       nombre_unidad_temp,
                                       id_curso_temp,
                                       nombre_curso_temp,
                                       cod_prioridad_temp,
                                       tipo_nodo_temp,
                                       id_correlativo_key,
                                       horas_temp,
                                       cantidad_temp 
                                       FROM ttemporal WHERE ' || v_consultaTemp;
					      /*************
                          FOR item1 IN(SELECT 
                                       id_correlativo,
                                       id_uo_t_temp,	
                                       id_uo_padre_temp, 
                                       id_uo_temp,
                                       nombre_unidad_temp,
                                       id_curso_temp,
                                       cod_prioridad_temp,
                                       tipo_nodo_temp,
                                       id_correlativo_key,
                                       horas_temp,
                                       cantidad_temp 
                                       FROM ttemporal)loop
                          RAISE EXCEPTION '%',item1.id_correlativo_key;                                 
                          END LOOP;                  	
						  *************/  
                      END IF;                                                                                               
                RETURN v_consulta;       	
		    END;             
    /******************************************/                                            
	ELSE
    	RAISE EXCEPTION 'Transaccion inexistente';
  	END IF;
  					
	EXCEPTION					
		WHEN OTHERS
          THEN
            v_resp='';
            v_resp = pxp.f_agrega_clave(v_resp,'mensaje',SQLERRM);
            v_resp = pxp.f_agrega_clave(v_resp,'codigo_error',SQLSTATE);
            v_resp = pxp.f_agrega_clave(v_resp,'procedimientos',v_nombre_funcion);
            RAISE EXCEPTION '%',v_resp;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
COST 100;