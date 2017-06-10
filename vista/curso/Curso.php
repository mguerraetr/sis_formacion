<?php
/**
 * @package pXP
 * @file gen-Curso.php
 * @author  (admin)
 * @date 23-01-2017 13:34:58
 * @description Archivo con la interfaz de usuario que permite la ejecucion de todas las funcionalidades del sistema
 */

header("content-type: text/javascript; charset=UTF-8");
?>

<script>
	var v_maestro =null;
	var valor;
	var valor2;
    Phx.vista.Curso = Ext.extend(Phx.gridInterfaz, {

            constructor: function (config) {
                this.maestro = config.maestro;
                v_maestro = config.maestro;
                //llama al constructor de la clase padre
                Phx.vista.Curso.superclass.constructor.call(this, config);
                this.init();
                this.load({params: {start: 0, limit: this.tam_pag}})
                this.iniciarEventos();
            },
           
            //
            iniciarEventos: function () {
                this.Cmp.id_lugar_pais.on('select', function (Combo, dato) {
                    this.cargarPaiseLugares(Combo);
                }, this);
            },
            //
            cargarPaiseLugares: function (Combo) {
                this.Cmp.id_lugar.store.setBaseParam('id_lugar_padre', Combo.getValue());
                this.Cmp.id_lugar.modificado = true;
            },
            //   
	        onButtonEdit: function () {
	            Phx.vista.Curso.superclass.onButtonEdit.call(this);
	            this.cargarPaiseLugares(this.Cmp.id_lugar_pais);
	        },
	        //
	        onReloadPage: function (m) {
	           this.maestro = m;
	           console.log('maestro:',this.maestro);        
	        },
	        //	                
          	onSubmit: function(o, x, force) {
    			var me = this;    			
				if (me.form.getForm().isValid() || force===true) {
		            Phx.CP.loadingShow();
		            Ext.apply(me.argumentSave, o.argument); 
		            
	            	var a = me.Cmp.origen.lastSelectionText;
	            	if(a=='Externo' || a=='Interno'){
	            		if(me.Cmp.id_proveedor.lastSelectionText === undefined || me.Cmp.id_proveedor.lastSelectionText === ''){
	            			alert("Seleccione algun proveedor");
		            		Phx.CP.loadingHide();
	            		}else{
	            			Ext.Ajax.request({
								url: '../../sis_formacion/control/Curso/insertarCurso',
								params: me.getValForm,
								success: me.successSave,
			                    argument: me.argumentSave,
			                    failure: me.conexionFailure,
			                    timeout: me.timeout,
			                    scope: me
							});	
	            		}	
	            	}else{
	            		Ext.Ajax.request({
							url: '../../sis_formacion/control/Curso/insertarCurso',
							params: me.getValForm,
							success: me.successSave,
		                    argument: me.argumentSave,
		                    failure: me.conexionFailure,
		                    timeout: me.timeout,
		                    scope: me
						});
	            	}			            	
			            	
		                     
        		}					
    	  	},
    	  	//
    	  	successSave: function(resp) {
    	  		this.store.rejectChanges();
				Phx.CP.loadingHide();
				if(resp.argument && resp.argument.news){
					if(resp.argument.def == 'reset'){
					  this.onButtonNew();
					}					
					this.loadValoresIniciales()
				}
				else{
					this.window.hide();
				}		
				this.reload();
	        },
    	  	//
    	  	getValForm: function() {
        		var resp = {};
		        for (var i = 0; i < this.Componentes.length; i++) {
		            var ac = this.Atributos[i];
		            var cmp = this.Componentes[i]
		            var swc = true;
		            if (ac.vista) {
		                swc = false;
		                for (var _p in ac.vista) {
		                    if (this.nombreVista == ac.vista[_p]) {
		                        swc = true;
		                        break;
		                    }
		                }
		            }		
		            if (ac.form != false && swc) {                
		                var _name = ac.config.name;
		                if (cmp.getValue() != '' && ac.type == 'DateField' && ac.config.format) {
		                    resp[_name] = cmp.getValue().dateFormat(ac.config.format)
		                    } 
		              else {
		              	    if(ac.type == 'ComboBox' && ac.config.rawValueField){
		              	    	resp[_name] =cmp.getValue();
		              	    	if ( cmp.getRawValue()==resp[_name] ){
		              	    		resp[ac.config.rawValueField] = cmp.getRawValue();
		              	    		resp[_name]=null;
		              	    	}
		              	    }
		              	    else{
		                        resp[_name] = cmp.getValue();
		              	    }
		                }
		            }
		        }
		        this.agregarArgsExtraSubmit();
		        this.agregarArgsBaseSubmit();
		        Ext.apply(resp, this.argumentExtraSubmit);
		        Ext.apply(resp, this.argumentBaseSubmit);
		        return resp
		    },    	  	
			//
            Atributos: [
                {
                    config: {
                        labelSeparator: '',
                        inputType: 'hidden',
                        name: 'id_curso'
                    },
                    type: 'Field',
                    form: true
                },
                {
                    config: {
                        //enviar erreglo
                        name: 'id_planificaciones',
                        fieldLabel: 'Planificacion',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_formacion/control/Planificacion/listarPlanificacion',
                            id: 'id_planificacion',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre_planificacion',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_planificacion', 'nombre_planificacion'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'nombre_planificacion'}
                        }),
                        valueField: 'id_planificacion',
                        displayField: 'nombre_planificacion',
                        gdisplayField: 'nombre_planificacion',
                        hiddenName: 'id_planificacion',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['planificaciones']);
                        }
                    },
                    type: 'AwesomeCombo',
                    id_grupo: 0,
                    filters: {pfiltro: 'sigefop.nombre_planificacion', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_gestion',
                        fieldLabel: 'Gestion',
                        allowBlank: false,
                        emptyText: 'Gestion...',
                        blankText: 'Año',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/Gestion/listarGestion',
                            id: 'id_gestion',
                            root: 'datos',
                            sortInfo: {
                                field: 'gestion',
                                direction: 'DESC'
                            },
                            totalProperty: 'total',
                            fields: ['id_gestion', 'gestion'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'gestion'}
                        }),
                        valueField: 'id_gestion',
                        displayField: 'gestion',
                        gdisplayField: 'gestion',
                        hiddenName: 'id_gestion',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 80,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['gestion']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'movtip.nombre', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'nombre_curso',
                        fieldLabel: 'Curso',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 500
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'cur.nombre_curso', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'contenido',
                        fieldLabel: 'Contenido',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 1000
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'cur.contenido', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'cod_tipo',
                        fieldLabel: 'Tipo',
                        tinit: false,
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        origen: 'CATALOGO',
                        gdisplayField: 'tipo',
                        gwidth: 70,
                        anchor: '80%',
                        baseParams: {
                            cod_subsistema: 'SIGEFO',
                            catalogo_tipo: 'tipo_curso'
                        },
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['cod_tipo']);
                        }
                    },
                    type: 'ComboRec',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'sigefoco.tipo',
                        type: 'string'
                    },
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'cod_prioridad',
                        fieldLabel: 'Prioridad',
                        tinit: false,
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        origen: 'CATALOGO',
                        gdisplayField: 'prioridad',
                        gwidth: 70,
                        anchor: '80%',
                        baseParams: {
                            cod_subsistema: 'SIGEFO',
                            catalogo_tipo: 'prioridad_curso'
                        },
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['cod_prioridad']);
                        }
                    },
                    type: 'ComboRec',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'sigefoco.prioridad',
                        type: 'string'
                    },
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'cod_clasificacion',
                        fieldLabel: 'Clasificación',
                        tinit: false,
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        origen: 'CATALOGO',
                        gdisplayField: 'clasificacion',
                        gwidth: 100,
                        anchor: '80%',
                        baseParams: {
                            cod_subsistema: 'SIGEFO',
                            catalogo_tipo: 'clasificacion_curso'
                        },
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['cod_clasificacion']);
                        }
                    },
                    type: 'ComboRec',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'sigefoco.clasificacion',
                        type: 'string'
                    },
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'objetivo',
                        fieldLabel: 'Objetivo',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 1000
                    },
                    type: 'TextArea',
                    filters: {pfiltro: 'cur.objetivo', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_competencias',
                        fieldLabel: 'Competencia',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_formacion/control/Competencia/listarCompetencia',
                            id: 'id_competencia',
                            root: 'datos',
                            sortInfo: {
                                field: 'competencia',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_competencia', 'competencia'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'competencia'}
                        }),
                        valueField: 'id_competencia',
                        displayField: 'competencia',
                        gdisplayField: 'competencia',
                        hiddenName: 'id_competencias',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 5,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['competencias']);
                        }
                    },
                    type: 'AwesomeCombo',
                    id_grupo: 0,
                    filters: {pfiltro: 'competencia', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_funcionarios',
                        fieldLabel: 'Funcionario',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_organigrama/control/Funcionario/listarFuncionario',
                            id: 'id_funcionario',
                            root: 'datos',
                            sortInfo: {
                                field: 'desc_person',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_funcionario', 'codigo', 'desc_person', 'ci', 'documento', 'telefono', 'celular', 'correo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'FUNCIO.codigo#PERSON.nombre_completo2'}

                        }),
                        valueField: 'id_funcionario',
                        displayField: 'desc_person',
                        tpl: '<tpl for="."> <div class="x-combo-list-item" ><div class="awesomecombo-item {checked}">{codigo}</div> <p>{desc_person}</p> <p>CI:{ci}</p> </div></tpl>',
                        gdisplayField: 'desc_person',
                        hiddenName: 'id_funcionario',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        enableMultiSelect: true,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['funcionarios']);
                        }
                    },
                    type: 'AwesomeCombo',
                    id_grupo: 0,
                    filters: {pfiltro: 'PERSON.desc_funcionario1', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_inicio',
                        fieldLabel: 'Fecha inicio',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cur.fecha_inicio', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'fecha_fin',
                        fieldLabel: 'Fecha fin',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cur.fecha_fin', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'horas',
                        fieldLabel: 'Horas',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'NumberField',
                    filters: {pfiltro: 'cur.horas', type: 'numeric'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_lugar_pais',
                        fieldLabel: 'Pais',
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/Lugar/listarLugar',
                            id: 'id_',
                            root: 'datos',
                            sortInfo: {
                                field: 'nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_lugar', 'nombre', 'tipo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'nombre', tipo: 'pais'}
                        }),
                        valueField: 'id_lugar', //srtore del combo
                        displayField: 'nombre', //estore del combo
                        gdisplayField: 'nombre_pais', //datos del store del grid
                        hiddenName: 'id_lugar_pais',// datos del store del grid
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['nombre_pais']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'lp.id_lugar_pais', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_lugar',
                        fieldLabel: 'Lugar',
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_formacion/control/Curso/listarPaisLugar',
                            id: 'id_lugar',
                            root: 'datos',
                            sortInfo: {
                                field: 'lug.nombre',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_lugar', 'nombre', 'tipo'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'lug.nombre',tipo:'pais'}
                        }),
                        valueField: 'id_lugar',
                        displayField: 'nombre',
                        gdisplayField: 'nombre',
                        hiddenName: 'id_lugar',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['nombre']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'lug.nombre', type: 'string'},
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'origen',
                        fieldLabel: 'Origen',
                        anchor: '90%',
                        tinit: false,
                        allowBlank: false,
                        emptyText: 'Elija una opción...',
                        origen: 'CATALOGO',
                        gdisplayField: 'origen',
                        gwidth: 200,
                        anchor: '80%',
                        baseParams: {
                            cod_subsistema: 'SIGEFO',
                            catalogo_tipo: 'origen_curso'
                        },
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['origen']);
                        }
                    },
                    type: 'ComboRec',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'sigefoco.origen',
                        type: 'string'
                    },
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'expositor',
                        fieldLabel: 'Expositor',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 50
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'cur.expositor', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'id_proveedor',
                        fieldLabel: 'Proveedor',
                        allowBlank: true,
                        emptyText: 'Proveedores...',
                        blankText: 'Debe seleccionar un proveedor',
                        store: new Ext.data.JsonStore({
                            url: '../../sis_parametros/control/Proveedor/listarProveedorCombos',
                            id: 'id_proveedor',
                            root: 'datos',
                            sortInfo: {
                                field: 'desc_proveedor',
                                direction: 'ASC'
                            },
                            totalProperty: 'total',
                            fields: ['id_proveedor', 'desc_proveedor'],
                            remoteSort: true,
                            baseParams: {par_filtro: 'desc_proveedor'}
                        }),
                        valueField: 'id_proveedor',
                        displayField: 'desc_proveedor',
                        gdisplayField: 'desc_proveedor',
                        hiddenName: 'id_proveedor',
                        forceSelection: true,
                        typeAhead: false,
                        triggerAction: 'all',
                        lazyRender: true,
                        mode: 'remote',
                        pageSize: 15,
                        queryDelay: 1000,
                        anchor: '80%',
                        gwidth: 150,
                        minChars: 2,
                        renderer: function (value, p, record) {
                            return String.format('{0}', record.data['desc_proveedor']);
                        }
                    },
                    type: 'ComboBox',
                    id_grupo: 0,
                    filters: {pfiltro: 'desc_proveedor', type: 'string'},
                    grid: true,
                    form: true
                },                
                {
                    config: {
                        name: 'evaluacion',
                        fieldLabel: 'Evaluacion',
                        tinit: false,
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        origen: 'CATALOGO',
                        gdisplayField: 'evaluacion',
                        gwidth: 50,
                        anchor: '80%',
                        baseParams: {
                            cod_subsistema: 'SIGEFO',
                            catalogo_tipo: 'evaluacion_curso'
                        },
                        renderer: function (value, p, record) {                   	
                            return String.format('{0}', record.data['evaluacion']);
                        },listeners: {
						   'afterrender': function(combo){				   
    							combo.setValue('NO');        
						  	}
						}
                    },
                    type: 'ComboRec',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'sigefoco.evaluacion',
                        type: 'string'
                    },
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'certificacion',
                        fieldLabel: 'Certificacion',
                        tinit: false,
                        allowBlank: true,
                        emptyText: 'Elija una opción...',
                        origen: 'CATALOGO',
                        gdisplayField: 'certificacion',
                        gwidth: 50,
                        anchor: '80%',
                        baseParams: {
                            cod_subsistema: 'SIGEFO',
                            catalogo_tipo: 'certificacion_curso'
                        },
                        renderer: function (value, p, record) {   	
                            return String.format('{0}', record.data['certificacion']);
                        },listeners: {
						   'afterrender': function(combo){			  
    							combo.setValue('NO');       
						  	}
						}
                    },
                    type: 'ComboRec',
                    id_grupo: 0,
                    filters: {
                        pfiltro: 'sigefoco.certificacion',
                        type: 'string'
                    },
                    grid: true,
                    form: true
                },
                {
                    config: {
                        name: 'estado_reg',
                        fieldLabel: 'Estado Reg.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 10
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'cur.estado_reg', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'id_usuario_ai',
                        fieldLabel: '',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'cur.id_usuario_ai', type: 'numeric'},
                    id_grupo: 1,
                    grid: false,
                    form: false
                },
                {
                    config: {
                        name: 'fecha_reg',
                        fieldLabel: 'Fecha creación',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y H:i:s') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cur.fecha_reg', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'usuario_ai',
                        fieldLabel: 'Funcionaro AI',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 300
                    },
                    type: 'TextField',
                    filters: {pfiltro: 'cur.usuario_ai', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'usr_reg',
                        fieldLabel: 'Creado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'usu1.cuenta', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'usr_mod',
                        fieldLabel: 'Modificado por',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        maxLength: 4
                    },
                    type: 'Field',
                    filters: {pfiltro: 'usu2.cuenta', type: 'string'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                },
                {
                    config: {
                        name: 'fecha_mod',
                        fieldLabel: 'Fecha Modif.',
                        allowBlank: true,
                        anchor: '80%',
                        gwidth: 100,
                        format: 'd/m/Y',
                        renderer: function (value, p, record) {
                            return value ? value.dateFormat('d/m/Y H:i:s') : ''
                        }
                    },
                    type: 'DateField',
                    filters: {pfiltro: 'cur.fecha_mod', type: 'date'},
                    id_grupo: 1,
                    grid: true,
                    form: false
                }
            ],
            tam_pag: 50,
            argumentSave: {},
            timeout: Phx.CP.config_ini.timeout,
    		conexionFailure: Phx.CP.conexionFailure,
            title: 'Curso',
            ActSave: '../../sis_formacion/control/Curso/insertarCurso',
            ActDel: '../../sis_formacion/control/Curso/eliminarCurso',
            ActList: '../../sis_formacion/control/Curso/listarCurso',
            id_store: 'id_curso',
            fields: [
                {name: 'id_curso', type: 'numeric'},
                {name: 'id_gestion', type: 'numeric'},
                {name: 'id_lugar', type: 'numeric'},
                {name: 'id_lugar_pais', type: 'numeric'},
                {name: 'id_proveedor', type: 'numeric'},
                {name: 'horas', type: 'numeric'},
                {name: 'cod_tipo', type: 'string'},
                {name: 'cod_prioridad', type: 'string'},
                {name: 'evaluacion', type: 'string'},
                {name: 'certificacion', type: 'string'},
                {name: 'cod_clasificacion', type: 'string'},
                {name: 'nombre_curso', type: 'string'},
                {name: 'expositor', type: 'string'},
                {name: 'origen', type: 'string'},
                {name: 'fecha_inicio', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'estado_reg', type: 'string'},
                {name: 'objetivo', type: 'string'},
                {name: 'contenido', type: 'string'},
                {name: 'fecha_fin', type: 'date', dateFormat: 'Y-m-d'},
                {name: 'id_usuario_ai', type: 'numeric'},
                {name: 'fecha_reg', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usuario_ai', type: 'string'},
                {name: 'id_usuario_reg', type: 'numeric'},
                {name: 'id_usuario_mod', type: 'numeric'},
                {name: 'fecha_mod', type: 'date', dateFormat: 'Y-m-d H:i:s.u'},
                {name: 'usr_reg', type: 'string'},
                {name: 'usr_mod', type: 'string'},
                {name: 'gestion', type: 'string'},
                {name: 'nombre', type: 'string'},
                {name: 'nombre_pais', type: 'string'},
                {name: 'desc_proveedor', type: 'string'},
                {name: 'id_competencias', type: 'string'},
                {name: 'competencias', type: 'string'},
                {name: 'id_planificaciones', type: 'string'},
                {name: 'planificaciones', type: 'string'},
                {name: 'id_funcionarios', type: 'string'},
                {name: 'funcionarios', type: 'string'}
            ],
            sortInfo: {
                field: 'id_curso',
                direction: 'ASC'
            },
            bdel: true,
            bsave: false,
            tabeast: 
			[{
	            url: '../../../sis_formacion/vista/curso/FormCursoAvanceReal.php',
                title: 'Avance Real',
                width: 800,
                cls: 'FormCursoAvanceReal'
	        }]
        }
    )
</script>
		
		