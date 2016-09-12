pragma Ada_95;
pragma Warnings (Off);
with System;
package ada_main is

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2016 (20160515-49)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_pr_a" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#7339e8d7#;
   pragma Export (C, u00001, "pr_aB");
   u00002 : constant Version_32 := 16#b6df930e#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#337e9ce1#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#f77a07a6#;
   pragma Export (C, u00004, "polyorb_hiS");
   u00005 : constant Version_32 := 16#a59bb26b#;
   pragma Export (C, u00005, "polyorb_hi__suspendersB");
   u00006 : constant Version_32 := 16#3f98daae#;
   pragma Export (C, u00006, "polyorb_hi__suspendersS");
   u00007 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00007, "adaS");
   u00008 : constant Version_32 := 16#fd8fe032#;
   pragma Export (C, u00008, "ada__real_time__delaysB");
   u00009 : constant Version_32 := 16#a062f703#;
   pragma Export (C, u00009, "ada__real_time__delaysS");
   u00010 : constant Version_32 := 16#472fa979#;
   pragma Export (C, u00010, "ada__exceptionsB");
   u00011 : constant Version_32 := 16#a2017425#;
   pragma Export (C, u00011, "ada__exceptionsS");
   u00012 : constant Version_32 := 16#e947e6a9#;
   pragma Export (C, u00012, "ada__exceptions__last_chance_handlerB");
   u00013 : constant Version_32 := 16#41e5552e#;
   pragma Export (C, u00013, "ada__exceptions__last_chance_handlerS");
   u00014 : constant Version_32 := 16#c3282aa7#;
   pragma Export (C, u00014, "systemS");
   u00015 : constant Version_32 := 16#5f84b5ab#;
   pragma Export (C, u00015, "system__soft_linksB");
   u00016 : constant Version_32 := 16#5dacf2f2#;
   pragma Export (C, u00016, "system__soft_linksS");
   u00017 : constant Version_32 := 16#b01dad17#;
   pragma Export (C, u00017, "system__parametersB");
   u00018 : constant Version_32 := 16#bd0227d8#;
   pragma Export (C, u00018, "system__parametersS");
   u00019 : constant Version_32 := 16#0f0cb66d#;
   pragma Export (C, u00019, "system__secondary_stackB");
   u00020 : constant Version_32 := 16#6849e5ce#;
   pragma Export (C, u00020, "system__secondary_stackS");
   u00021 : constant Version_32 := 16#39a03df9#;
   pragma Export (C, u00021, "system__storage_elementsB");
   u00022 : constant Version_32 := 16#eeeb60a3#;
   pragma Export (C, u00022, "system__storage_elementsS");
   u00023 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00023, "system__stack_checkingB");
   u00024 : constant Version_32 := 16#4d97414f#;
   pragma Export (C, u00024, "system__stack_checkingS");
   u00025 : constant Version_32 := 16#87a448ff#;
   pragma Export (C, u00025, "system__exception_tableB");
   u00026 : constant Version_32 := 16#9e8643e5#;
   pragma Export (C, u00026, "system__exception_tableS");
   u00027 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00027, "system__exceptionsB");
   u00028 : constant Version_32 := 16#ab4b4751#;
   pragma Export (C, u00028, "system__exceptionsS");
   u00029 : constant Version_32 := 16#4c9e814d#;
   pragma Export (C, u00029, "system__exceptions__machineS");
   u00030 : constant Version_32 := 16#aa0563fc#;
   pragma Export (C, u00030, "system__exceptions_debugB");
   u00031 : constant Version_32 := 16#bda2d363#;
   pragma Export (C, u00031, "system__exceptions_debugS");
   u00032 : constant Version_32 := 16#6c2f8802#;
   pragma Export (C, u00032, "system__img_intB");
   u00033 : constant Version_32 := 16#c1f3ca65#;
   pragma Export (C, u00033, "system__img_intS");
   u00034 : constant Version_32 := 16#39df8c17#;
   pragma Export (C, u00034, "system__tracebackB");
   u00035 : constant Version_32 := 16#9d0af463#;
   pragma Export (C, u00035, "system__tracebackS");
   u00036 : constant Version_32 := 16#9ed49525#;
   pragma Export (C, u00036, "system__traceback_entriesB");
   u00037 : constant Version_32 := 16#c373dcd7#;
   pragma Export (C, u00037, "system__traceback_entriesS");
   u00038 : constant Version_32 := 16#6fd210f2#;
   pragma Export (C, u00038, "system__traceback__symbolicB");
   u00039 : constant Version_32 := 16#dd19f67a#;
   pragma Export (C, u00039, "system__traceback__symbolicS");
   u00040 : constant Version_32 := 16#701f9d88#;
   pragma Export (C, u00040, "ada__exceptions__tracebackB");
   u00041 : constant Version_32 := 16#20245e75#;
   pragma Export (C, u00041, "ada__exceptions__tracebackS");
   u00042 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00042, "system__address_imageB");
   u00043 : constant Version_32 := 16#62c4b79d#;
   pragma Export (C, u00043, "system__address_imageS");
   u00044 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00044, "system__wch_conB");
   u00045 : constant Version_32 := 16#d8550875#;
   pragma Export (C, u00045, "system__wch_conS");
   u00046 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00046, "system__wch_stwB");
   u00047 : constant Version_32 := 16#f5442474#;
   pragma Export (C, u00047, "system__wch_stwS");
   u00048 : constant Version_32 := 16#a831679c#;
   pragma Export (C, u00048, "system__wch_cnvB");
   u00049 : constant Version_32 := 16#d7e2b286#;
   pragma Export (C, u00049, "system__wch_cnvS");
   u00050 : constant Version_32 := 16#5ab55268#;
   pragma Export (C, u00050, "interfacesS");
   u00051 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00051, "system__wch_jisB");
   u00052 : constant Version_32 := 16#5792aba7#;
   pragma Export (C, u00052, "system__wch_jisS");
   u00053 : constant Version_32 := 16#9fad3aa0#;
   pragma Export (C, u00053, "ada__real_timeB");
   u00054 : constant Version_32 := 16#8a504209#;
   pragma Export (C, u00054, "ada__real_timeS");
   u00055 : constant Version_32 := 16#a540e70d#;
   pragma Export (C, u00055, "system__taskingB");
   u00056 : constant Version_32 := 16#2410879e#;
   pragma Export (C, u00056, "system__taskingS");
   u00057 : constant Version_32 := 16#ae36db3a#;
   pragma Export (C, u00057, "system__task_primitivesS");
   u00058 : constant Version_32 := 16#eba442ab#;
   pragma Export (C, u00058, "system__os_interfaceB");
   u00059 : constant Version_32 := 16#225a1d94#;
   pragma Export (C, u00059, "system__os_interfaceS");
   u00060 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00060, "interfaces__cB");
   u00061 : constant Version_32 := 16#70be4e8c#;
   pragma Export (C, u00061, "interfaces__cS");
   u00062 : constant Version_32 := 16#24379d76#;
   pragma Export (C, u00062, "interfaces__c__extensionsS");
   u00063 : constant Version_32 := 16#acefa820#;
   pragma Export (C, u00063, "system__os_constantsS");
   u00064 : constant Version_32 := 16#738dd9f2#;
   pragma Export (C, u00064, "system__task_primitives__operationsB");
   u00065 : constant Version_32 := 16#0980a7f3#;
   pragma Export (C, u00065, "system__task_primitives__operationsS");
   u00066 : constant Version_32 := 16#89b55e64#;
   pragma Export (C, u00066, "system__interrupt_managementB");
   u00067 : constant Version_32 := 16#5e06908e#;
   pragma Export (C, u00067, "system__interrupt_managementS");
   u00068 : constant Version_32 := 16#f65595cf#;
   pragma Export (C, u00068, "system__multiprocessorsB");
   u00069 : constant Version_32 := 16#fb84b5d4#;
   pragma Export (C, u00069, "system__multiprocessorsS");
   u00070 : constant Version_32 := 16#a6535153#;
   pragma Export (C, u00070, "system__os_primitivesB");
   u00071 : constant Version_32 := 16#49a73bd1#;
   pragma Export (C, u00071, "system__os_primitivesS");
   u00072 : constant Version_32 := 16#e0fce7f8#;
   pragma Export (C, u00072, "system__task_infoB");
   u00073 : constant Version_32 := 16#433297a6#;
   pragma Export (C, u00073, "system__task_infoS");
   u00074 : constant Version_32 := 16#85267e7e#;
   pragma Export (C, u00074, "system__tasking__debugB");
   u00075 : constant Version_32 := 16#511cd042#;
   pragma Export (C, u00075, "system__tasking__debugS");
   u00076 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00076, "system__concat_2B");
   u00077 : constant Version_32 := 16#c188fd77#;
   pragma Export (C, u00077, "system__concat_2S");
   u00078 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00078, "system__concat_3B");
   u00079 : constant Version_32 := 16#c8587602#;
   pragma Export (C, u00079, "system__concat_3S");
   u00080 : constant Version_32 := 16#b3b9fca9#;
   pragma Export (C, u00080, "system__crtlS");
   u00081 : constant Version_32 := 16#d0432c8d#;
   pragma Export (C, u00081, "system__img_enum_newB");
   u00082 : constant Version_32 := 16#a2642c67#;
   pragma Export (C, u00082, "system__img_enum_newS");
   u00083 : constant Version_32 := 16#9dca6636#;
   pragma Export (C, u00083, "system__img_lliB");
   u00084 : constant Version_32 := 16#d2677f76#;
   pragma Export (C, u00084, "system__img_lliS");
   u00085 : constant Version_32 := 16#f7ae5624#;
   pragma Export (C, u00085, "system__unsigned_typesS");
   u00086 : constant Version_32 := 16#118e865d#;
   pragma Export (C, u00086, "system__stack_usageB");
   u00087 : constant Version_32 := 16#3a3ac346#;
   pragma Export (C, u00087, "system__stack_usageS");
   u00088 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00088, "system__ioB");
   u00089 : constant Version_32 := 16#5d6adde8#;
   pragma Export (C, u00089, "system__ioS");
   u00090 : constant Version_32 := 16#6fbb4e8d#;
   pragma Export (C, u00090, "ada__synchronous_task_controlB");
   u00091 : constant Version_32 := 16#bc96dc39#;
   pragma Export (C, u00091, "ada__synchronous_task_controlS");
   u00092 : constant Version_32 := 16#920eada5#;
   pragma Export (C, u00092, "ada__tagsB");
   u00093 : constant Version_32 := 16#13ca27f3#;
   pragma Export (C, u00093, "ada__tagsS");
   u00094 : constant Version_32 := 16#c3335bfd#;
   pragma Export (C, u00094, "system__htableB");
   u00095 : constant Version_32 := 16#47ea994d#;
   pragma Export (C, u00095, "system__htableS");
   u00096 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00096, "system__string_hashB");
   u00097 : constant Version_32 := 16#e5b4f233#;
   pragma Export (C, u00097, "system__string_hashS");
   u00098 : constant Version_32 := 16#afdbf393#;
   pragma Export (C, u00098, "system__val_lluB");
   u00099 : constant Version_32 := 16#8d5c0156#;
   pragma Export (C, u00099, "system__val_lluS");
   u00100 : constant Version_32 := 16#27b600b2#;
   pragma Export (C, u00100, "system__val_utilB");
   u00101 : constant Version_32 := 16#6f889c59#;
   pragma Export (C, u00101, "system__val_utilS");
   u00102 : constant Version_32 := 16#d1060688#;
   pragma Export (C, u00102, "system__case_utilB");
   u00103 : constant Version_32 := 16#e7214370#;
   pragma Export (C, u00103, "system__case_utilS");
   u00104 : constant Version_32 := 16#cf417de3#;
   pragma Export (C, u00104, "ada__finalizationS");
   u00105 : constant Version_32 := 16#10558b11#;
   pragma Export (C, u00105, "ada__streamsB");
   u00106 : constant Version_32 := 16#2e6701ab#;
   pragma Export (C, u00106, "ada__streamsS");
   u00107 : constant Version_32 := 16#db5c917c#;
   pragma Export (C, u00107, "ada__io_exceptionsS");
   u00108 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00108, "system__finalization_rootB");
   u00109 : constant Version_32 := 16#8cda5937#;
   pragma Export (C, u00109, "system__finalization_rootS");
   u00110 : constant Version_32 := 16#6150ea68#;
   pragma Export (C, u00110, "ada__task_identificationB");
   u00111 : constant Version_32 := 16#3df36169#;
   pragma Export (C, u00111, "ada__task_identificationS");
   u00112 : constant Version_32 := 16#67e431ef#;
   pragma Export (C, u00112, "system__tasking__utilitiesB");
   u00113 : constant Version_32 := 16#51068caf#;
   pragma Export (C, u00113, "system__tasking__utilitiesS");
   u00114 : constant Version_32 := 16#71e7b7a1#;
   pragma Export (C, u00114, "system__tasking__initializationB");
   u00115 : constant Version_32 := 16#ed62fcff#;
   pragma Export (C, u00115, "system__tasking__initializationS");
   u00116 : constant Version_32 := 16#eeadc70a#;
   pragma Export (C, u00116, "system__soft_links__taskingB");
   u00117 : constant Version_32 := 16#5ae92880#;
   pragma Export (C, u00117, "system__soft_links__taskingS");
   u00118 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00118, "ada__exceptions__is_null_occurrenceB");
   u00119 : constant Version_32 := 16#e1d7566f#;
   pragma Export (C, u00119, "ada__exceptions__is_null_occurrenceS");
   u00120 : constant Version_32 := 16#7995e1aa#;
   pragma Export (C, u00120, "system__tasking__task_attributesB");
   u00121 : constant Version_32 := 16#a1da3c09#;
   pragma Export (C, u00121, "system__tasking__task_attributesS");
   u00122 : constant Version_32 := 16#35ce8314#;
   pragma Export (C, u00122, "system__tasking__queuingB");
   u00123 : constant Version_32 := 16#05e644a6#;
   pragma Export (C, u00123, "system__tasking__queuingS");
   u00124 : constant Version_32 := 16#f83990e5#;
   pragma Export (C, u00124, "system__tasking__protected_objectsB");
   u00125 : constant Version_32 := 16#5744f344#;
   pragma Export (C, u00125, "system__tasking__protected_objectsS");
   u00126 : constant Version_32 := 16#ee80728a#;
   pragma Export (C, u00126, "system__tracesB");
   u00127 : constant Version_32 := 16#3135420d#;
   pragma Export (C, u00127, "system__tracesS");
   u00128 : constant Version_32 := 16#9fa349e0#;
   pragma Export (C, u00128, "system__tasking__protected_objects__entriesB");
   u00129 : constant Version_32 := 16#a0c7bfc6#;
   pragma Export (C, u00129, "system__tasking__protected_objects__entriesS");
   u00130 : constant Version_32 := 16#100eaf58#;
   pragma Export (C, u00130, "system__restrictionsB");
   u00131 : constant Version_32 := 16#6a886006#;
   pragma Export (C, u00131, "system__restrictionsS");
   u00132 : constant Version_32 := 16#bd6fc52e#;
   pragma Export (C, u00132, "system__traces__taskingB");
   u00133 : constant Version_32 := 16#0b40d4b2#;
   pragma Export (C, u00133, "system__traces__taskingS");
   u00134 : constant Version_32 := 16#6abe5dbe#;
   pragma Export (C, u00134, "system__finalization_mastersB");
   u00135 : constant Version_32 := 16#98d4136d#;
   pragma Export (C, u00135, "system__finalization_mastersS");
   u00136 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00136, "system__img_boolB");
   u00137 : constant Version_32 := 16#36f15b4c#;
   pragma Export (C, u00137, "system__img_boolS");
   u00138 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00138, "system__storage_poolsB");
   u00139 : constant Version_32 := 16#e0c5b40a#;
   pragma Export (C, u00139, "system__storage_poolsS");
   u00140 : constant Version_32 := 16#dd29c6d8#;
   pragma Export (C, u00140, "polyorb_hi__epochB");
   u00141 : constant Version_32 := 16#75e0d918#;
   pragma Export (C, u00141, "polyorb_hi__epochS");
   u00142 : constant Version_32 := 16#32a22d97#;
   pragma Export (C, u00142, "polyorb_hi_generatedS");
   u00143 : constant Version_32 := 16#9c74e642#;
   pragma Export (C, u00143, "polyorb_hi_generated__deploymentS");
   u00144 : constant Version_32 := 16#fade26d4#;
   pragma Export (C, u00144, "polyorb_hi__transport_low_levelB");
   u00145 : constant Version_32 := 16#c67e314a#;
   pragma Export (C, u00145, "polyorb_hi__transport_low_levelS");
   u00146 : constant Version_32 := 16#9a911172#;
   pragma Export (C, u00146, "polyorb_hi__errorsS");
   u00147 : constant Version_32 := 16#ddb82d85#;
   pragma Export (C, u00147, "polyorb_hi__streamsS");
   u00148 : constant Version_32 := 16#89bbbf8b#;
   pragma Export (C, u00148, "polyorb_hi_generated__activityB");
   u00149 : constant Version_32 := 16#4f34af71#;
   pragma Export (C, u00149, "polyorb_hi_generated__activityS");
   u00150 : constant Version_32 := 16#6d77eb3b#;
   pragma Export (C, u00150, "polyorb_hi__messagesB");
   u00151 : constant Version_32 := 16#c169da34#;
   pragma Export (C, u00151, "polyorb_hi__messagesS");
   u00152 : constant Version_32 := 16#ed7fecad#;
   pragma Export (C, u00152, "polyorb_hi__utilsB");
   u00153 : constant Version_32 := 16#73fc7d12#;
   pragma Export (C, u00153, "polyorb_hi__utilsS");
   u00154 : constant Version_32 := 16#52f1910f#;
   pragma Export (C, u00154, "system__assertionsB");
   u00155 : constant Version_32 := 16#0ea50633#;
   pragma Export (C, u00155, "system__assertionsS");
   u00156 : constant Version_32 := 16#aa750afc#;
   pragma Export (C, u00156, "polyorb_hi__outputB");
   u00157 : constant Version_32 := 16#def73f49#;
   pragma Export (C, u00157, "polyorb_hi__outputS");
   u00158 : constant Version_32 := 16#3f17e8e2#;
   pragma Export (C, u00158, "polyorb_hi__output_low_levelB");
   u00159 : constant Version_32 := 16#ce6fdc73#;
   pragma Export (C, u00159, "polyorb_hi__output_low_levelS");
   u00160 : constant Version_32 := 16#276453b7#;
   pragma Export (C, u00160, "system__img_lldB");
   u00161 : constant Version_32 := 16#300a23ce#;
   pragma Export (C, u00161, "system__img_lldS");
   u00162 : constant Version_32 := 16#bd3715ff#;
   pragma Export (C, u00162, "system__img_decB");
   u00163 : constant Version_32 := 16#6d05237c#;
   pragma Export (C, u00163, "system__img_decS");
   u00164 : constant Version_32 := 16#5a5f008c#;
   pragma Export (C, u00164, "polyorb_hi__port_kindsB");
   u00165 : constant Version_32 := 16#51cef81a#;
   pragma Export (C, u00165, "polyorb_hi__port_kindsS");
   u00166 : constant Version_32 := 16#82fe6eb4#;
   pragma Export (C, u00166, "polyorb_hi__port_type_marshallersB");
   u00167 : constant Version_32 := 16#31d6cd8d#;
   pragma Export (C, u00167, "polyorb_hi__port_type_marshallersS");
   u00168 : constant Version_32 := 16#e7e321ad#;
   pragma Export (C, u00168, "polyorb_hi__marshallers_gB");
   u00169 : constant Version_32 := 16#98b2e792#;
   pragma Export (C, u00169, "polyorb_hi__marshallers_gS");
   u00170 : constant Version_32 := 16#14e306d9#;
   pragma Export (C, u00170, "polyorb_hi__thread_interrogatorsB");
   u00171 : constant Version_32 := 16#bc879afe#;
   pragma Export (C, u00171, "polyorb_hi__thread_interrogatorsS");
   u00172 : constant Version_32 := 16#5d51f498#;
   pragma Export (C, u00172, "polyorb_hi__time_marshallersB");
   u00173 : constant Version_32 := 16#1cb2286e#;
   pragma Export (C, u00173, "polyorb_hi__time_marshallersS");
   u00174 : constant Version_32 := 16#477206f8#;
   pragma Export (C, u00174, "polyorb_hi_generated__marshallersB");
   u00175 : constant Version_32 := 16#6bf84caf#;
   pragma Export (C, u00175, "polyorb_hi_generated__marshallersS");
   u00176 : constant Version_32 := 16#5c71fbcc#;
   pragma Export (C, u00176, "polyorb_hi_generated__typesS");
   u00177 : constant Version_32 := 16#8e69d953#;
   pragma Export (C, u00177, "polyorb_hi_generated__subprogramsB");
   u00178 : constant Version_32 := 16#dfa981dd#;
   pragma Export (C, u00178, "polyorb_hi_generated__subprogramsS");
   u00179 : constant Version_32 := 16#c4f8a484#;
   pragma Export (C, u00179, "producer_consumerB");
   u00180 : constant Version_32 := 16#d0cb69cd#;
   pragma Export (C, u00180, "producer_consumerS");
   u00181 : constant Version_32 := 16#1a909cbc#;
   pragma Export (C, u00181, "polyorb_hi_generated__transportB");
   u00182 : constant Version_32 := 16#28649919#;
   pragma Export (C, u00182, "polyorb_hi_generated__transportS");
   u00183 : constant Version_32 := 16#ce83633b#;
   pragma Export (C, u00183, "system__tasking__protected_objects__operationsB");
   u00184 : constant Version_32 := 16#902e29cd#;
   pragma Export (C, u00184, "system__tasking__protected_objects__operationsS");
   u00185 : constant Version_32 := 16#d3d9b1ce#;
   pragma Export (C, u00185, "system__tasking__entry_callsB");
   u00186 : constant Version_32 := 16#ddf2aa0b#;
   pragma Export (C, u00186, "system__tasking__entry_callsS");
   u00187 : constant Version_32 := 16#9dcd4743#;
   pragma Export (C, u00187, "system__tasking__rendezvousB");
   u00188 : constant Version_32 := 16#3e44c873#;
   pragma Export (C, u00188, "system__tasking__rendezvousS");
   u00189 : constant Version_32 := 16#7ad44f28#;
   pragma Export (C, u00189, "polyorb_hi__periodic_taskB");
   u00190 : constant Version_32 := 16#af757f5c#;
   pragma Export (C, u00190, "polyorb_hi__periodic_taskS");
   u00191 : constant Version_32 := 16#fc9da4b5#;
   pragma Export (C, u00191, "system__tasking__stagesB");
   u00192 : constant Version_32 := 16#21a9077d#;
   pragma Export (C, u00192, "system__tasking__stagesS");
   u00193 : constant Version_32 := 16#a6359005#;
   pragma Export (C, u00193, "system__memoryB");
   u00194 : constant Version_32 := 16#9a554c93#;
   pragma Export (C, u00194, "system__memoryS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  interfaces%s
   --  system%s
   --  system.case_util%s
   --  system.case_util%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_dec%s
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_dec%b
   --  system.img_lld%s
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.img_lld%b
   --  system.io%s
   --  system.io%b
   --  system.multiprocessors%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_usage%s
   --  system.stack_usage%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  system.soft_links%s
   --  system.traces%s
   --  system.traces%b
   --  system.unsigned_types%s
   --  system.val_llu%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_llu%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  ada.exceptions.traceback%s
   --  system.address_image%s
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.io_exceptions%s
   --  ada.tags%s
   --  ada.streams%s
   --  ada.streams%b
   --  interfaces.c%s
   --  system.multiprocessors%b
   --  interfaces.c.extensions%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.interrupt_management%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.task_primitives%s
   --  system.tasking%s
   --  ada.task_identification%s
   --  ada.synchronous_task_control%s
   --  system.task_primitives.operations%s
   --  ada.synchronous_task_control%b
   --  system.tasking%b
   --  system.tasking.debug%s
   --  system.tasking.debug%b
   --  system.task_primitives.operations%b
   --  system.traces.tasking%s
   --  system.traces.tasking%b
   --  system.assertions%s
   --  system.assertions%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.secondary_stack%s
   --  system.finalization_masters%b
   --  interfaces.c%b
   --  ada.tags%b
   --  system.soft_links%b
   --  system.secondary_stack%b
   --  system.address_image%b
   --  ada.exceptions.traceback%b
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.tasking.entry_calls%s
   --  system.tasking.initialization%s
   --  system.tasking.task_attributes%s
   --  system.tasking.task_attributes%b
   --  system.tasking.utilities%s
   --  ada.task_identification%b
   --  system.traceback%s
   --  system.traceback%b
   --  system.traceback.symbolic%s
   --  system.traceback.symbolic%b
   --  ada.exceptions%b
   --  system.tasking.initialization%b
   --  ada.real_time%s
   --  ada.real_time%b
   --  ada.real_time.delays%s
   --  ada.real_time.delays%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.protected_objects.entries%s
   --  system.tasking.protected_objects.entries%b
   --  system.tasking.queuing%s
   --  system.tasking.queuing%b
   --  system.tasking.utilities%b
   --  system.tasking.rendezvous%s
   --  system.tasking.protected_objects.operations%s
   --  system.tasking.protected_objects.operations%b
   --  system.tasking.rendezvous%b
   --  system.tasking.entry_calls%b
   --  system.tasking.stages%s
   --  system.tasking.stages%b
   --  polyorb_hi%s
   --  polyorb_hi.streams%s
   --  polyorb_hi_generated%s
   --  polyorb_hi_generated.deployment%s
   --  polyorb_hi.utils%s
   --  polyorb_hi.utils%b
   --  polyorb_hi.epoch%s
   --  polyorb_hi.epoch%b
   --  polyorb_hi.errors%s
   --  polyorb_hi.messages%s
   --  polyorb_hi.messages%b
   --  polyorb_hi.marshallers_g%s
   --  polyorb_hi.marshallers_g%b
   --  polyorb_hi.output_low_level%s
   --  polyorb_hi.output_low_level%b
   --  polyorb_hi.output%s
   --  polyorb_hi.output%b
   --  polyorb_hi.periodic_task%s
   --  polyorb_hi.port_kinds%s
   --  polyorb_hi.port_kinds%b
   --  polyorb_hi.port_type_marshallers%s
   --  polyorb_hi.port_type_marshallers%b
   --  polyorb_hi.suspenders%s
   --  polyorb_hi.suspenders%b
   --  polyorb_hi.periodic_task%b
   --  polyorb_hi.thread_interrogators%s
   --  polyorb_hi.time_marshallers%s
   --  polyorb_hi.time_marshallers%b
   --  polyorb_hi.thread_interrogators%b
   --  polyorb_hi.transport_low_level%s
   --  polyorb_hi.transport_low_level%b
   --  polyorb_hi_generated.transport%s
   --  polyorb_hi_generated.types%s
   --  polyorb_hi_generated.activity%s
   --  polyorb_hi_generated.marshallers%s
   --  polyorb_hi_generated.marshallers%b
   --  polyorb_hi_generated.transport%b
   --  polyorb_hi_generated.subprograms%s
   --  polyorb_hi_generated.activity%b
   --  producer_consumer%s
   --  producer_consumer%b
   --  polyorb_hi_generated.subprograms%b
   --  pr_a%b
   --  END ELABORATION ORDER


end ada_main;
