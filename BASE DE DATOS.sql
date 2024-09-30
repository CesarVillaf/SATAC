CREATE DATABASE SATAC;

USE SATAC;

CREATE TABLE `user` (
	id_user INT AUTO_INCREMENT COMMENT 'Identificador único para los usuarios',
    first_name VARCHAR(50) NOT NULL COMMENT 'Primer nombre del usuario',
    middle_name VARCHAR(50) COMMENT 'Segundo nombre del usuario',
    last_name_father VARCHAR(50) NOT NULL COMMENT 'Apellido paterno del usuario',
    last_name_mother VARCHAR(50) COMMENT 'Apellido materno del usuario',
    email VARCHAR(100) NOT NULL COMMENT 'Dirección de correo electrónico del usuario',
    pass VARCHAR(255) NOT NULL COMMENT 'Constraseña del usuario (hashed)',
    validation_token VARCHAR(255) COMMENT 'Token para validar el correo electrónico del usuario',
    token_confirmed BOOLEAN DEFAULT FALSE COMMENT 'Estado de validación del token, por defecto en falso',
    is_admin BOOLEAN DEFAULT FALSE COMMENT 'Estado del administrador, por defecto en falso',
    CONSTRAINT pk_user PRIMARY KEY (id_user),
    CONSTRAINT uc_email UNIQUE KEY (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de usuarios';

CREATE TABLE category (
	id_category INT AUTO_INCREMENT COMMENT 'Identificador único de la categoría',
    category_name VARCHAR(255) NOT NULL COMMENT 'Nombre de la categoría',
    category_description TEXT NOT NULL COMMENT 'Descripción detallada de la categoría',
    category_status ENUM('active', 'inactive') DEFAULT 'active' COMMENT 'Estado de la categoría, por defecto en active',
    image_url VARCHAR(255) DEFAULT 'N/A' COMMENT 'URL de la imagen de la categoría',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la actualización del registro',
    CONSTRAINT pk_category PRIMARY KEY (id_category),
    KEY idx_category_name (category_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de categorías';
-- ('Otros', 'Productos que no encajan en ninguna categoría específica', 'active')

CREATE TABLE product (
	id_product INT NOT NULL COMMENT 'Identificador único del producto',
    id_category INT DEFAULT 1 COMMENT 'Identificador de la categoría, por defecto 1 (Otros)',
    product_name VARCHAR(255) NOT NULL COMMENT 'Nombre del producto',
    sale_price DECIMAL(10, 2) NOT NULL COMMENT 'Precio de venta del producto',
    product_type ENUM('unit', 'weight') NOT NULL DEFAULT 'unit' COMMENT 'Tipo de producto: unit (por unidad) o weight (por peso)',
    product_variant VARCHAR(255) DEFAULT 'N/A' COMMENT 'Variante del producto, por defecto N/A',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la actualización del registro',
    CONSTRAINT pk_product PRIMARY KEY (id_product),
    CONSTRAINT fk_product_category FOREIGN KEY (id_category) REFERENCES category(id_category)
    ON UPDATE CASCADE ON DELETE CASCADE,
    KEY idx_product_name (product_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de productos';

CREATE TABLE unit_of_measure (
	id_unit INT AUTO_INCREMENT COMMENT 'Identificador único de la unidad de medida',
    unit_description VARCHAR(50) NOT NULL COMMENT 'Descripción detallada de la unidad de medida',
    unit_abbreviation VARCHAR(10) NOT NULL COMMENT 'Abreviatura de la unidad de medida',
    unit_status ENUM('active', 'inactive') DEFAULT 'active' COMMENT 'Estado de la unidad de medida',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la actualización del registro',
    CONSTRAINT pk_unit_of_measure PRIMARY KEY (id_unit),
    CONSTRAINT uc_unit_abbreviation  UNIQUE KEY (unit_abbreviation)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de unidades de medida';
-- ('Desconocido', 'N/A', 'active')

CREATE TABLE product_description (
	id_product INT NOT NULL COMMENT 'Identificador único del producto, relación 1:1 con product',
	id_unit INT DEFAULT 1 COMMENT 'Identificador único de la unidad de medida del contenido neto, por defecto 1 (Desconocido)',
    net_content DECIMAL(10, 2) DEFAULT 0 COMMENT 'Contenido neto del producto, por defecto 0',
    purchase_price DECIMAL(10, 2) NOT NULL COMMENT 'Precio de compra del producto',
    CONSTRAINT pk_product_description PRIMARY KEY (id_product),
    CONSTRAINT fk_product_description FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_description_unit FOREIGN KEY (id_unit) REFERENCES unit_of_measure(id_unit)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de descripciones del producto';

CREATE TABLE promotion (
	id_promotion INT AUTO_INCREMENT COMMENT 'Identificador único de la promoción',
    id_product INT NOT NULL COMMENT 'Identificador único del producto',
    promo_price DECIMAL(10, 2) NOT NULL COMMENT 'Precio de promoción',
    promo_start_date DATE NOT NULL COMMENT 'Fecha y hora de inicio de la pormoción',
    promo_end_date DATE NOT NULL COMMENT 'Fecha y hora del fin de la promoción',
    CONSTRAINT pk_promotion PRIMARY KEY (id_promotion),
    CONSTRAINT fk_promotion_product FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de promociones';

CREATE TABLE bulk_offer (
	id_offer INT AUTO_INCREMENT COMMENT 'Identificador único de la oferta al por mayor',
    id_product INT NOT NULL COMMENT 'Identificador único del producto',
    quantity INT NOT NULL COMMENT 'Cantidad de productos al por mayor',
    offer_price DECIMAL(10, 2) NOT NULL COMMENT 'Precio de oferta al por mayor',
    offer_start_date DATE NOT NULL COMMENT 'Fecha y hora de inicio de la oferta al por mayor',
    offer_end_date DATE NOT NULL COMMENT 'Fecha y hora del fin de la oferta al por mayor',
    CONSTRAINT pk_bulk_offer PRIMARY KEY (id_offer),
    CONSTRAINT fk_bulk_offer_product FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de promociones';

CREATE TABLE combo_offer (
	id_combo INT AUTO_INCREMENT COMMENT 'Identificador único del combo',
    combo_name VARCHAR(255) NOT NULL COMMENT 'Nombre del combo',
    combo_price DECIMAL(10, 2) NOT NULL COMMENT 'Precio de oferta del combo',
    combo_start_date DATE NOT NULL COMMENT 'Fecha y hora de inicio del combo',
    combo_end_date DATE NOT NULL COMMENT 'Fecha y hora del fin del combo',
    CONSTRAINT pk_combo_offer PRIMARY KEY (id_combo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de oferta en combo';

CREATE TABLE combo_offer_product (
	id_combo INT NOT NULL COMMENT 'Identificador único del combo',
    id_product INT NOT NULL COMMENT 'Idenficador único del producto',
    CONSTRAINT pk_combo_offer_product PRIMARY KEY (id_combo, id_product),
    CONSTRAINT fk_combo_offer_product_combo FOREIGN KEY (id_combo) REFERENCES combo_offer(id_combo)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_combo_offer_product_product FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de relación entre oferta de combo y producto';

CREATE TABLE inventory (
    id_inventory INT AUTO_INCREMENT COMMENT 'Identificador único del inventario',
    id_product INT NOT NULL COMMENT 'Identificador único del producto',
	quantity INT DEFAULT 0 COMMENT 'Cantidad en inventario, por defecto 0',
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la última actualización',
    CONSTRAINT pk_inventory PRIMARY KEY (id_inventory),
    CONSTRAINT fk_inventory_product FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT chk_quantity_non_negative CHECK (quantity >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de inventario';

CREATE TABLE change_reason (
    id_reason INT AUTO_INCREMENT COMMENT 'Identificador único de la razón de cambio',
    reason_description ENUM('add', 'update', 'remove') NOT NULL COMMENT 'Descripción del motivo de cambio',
    CONSTRAINT pk_change_reason PRIMARY KEY (id_reason),
    CONSTRAINT uq_reason_descripion UNIQUE KEY (reason_description)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de motivos de cambio';

CREATE TABLE inventory_history (
    id_history INT AUTO_INCREMENT COMMENT 'Identificador único del historial de inventarios',
    id_inventory INT NOT NULL COMMENT 'Identidicador único del inventario',
    id_reason INT DEFAULT 1 COMMENT 'Identificador único de la razón de cambio, por defecto 1 (add)',
    quantity_changed INT NOT NULL COMMENT 'Cantidad que se ingresó o se retiró',
    total_quantity INT NOT NULL COMMENT 'Cantidad total después del cambio',
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del cambio del registro',
    CONSTRAINT pk_inventory_history PRIMARY KEY (id_history),
    CONSTRAINT fk_inventory_history_inventory FOREIGN KEY (id_inventory) REFERENCES inventory(id_inventory)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_inventory_history_reason FOREIGN KEY (id_reason) REFERENCES change_reason(id_reason)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla del historial de inventarios';

CREATE TABLE supplier (
	id_supplier INT AUTO_INCREMENT COMMENT 'Identificador único del proveedor',
    supplier_name VARCHAR(255) NOT NULL DEFAULT 'DESCONOCIDO' COMMENT 'Nombre del proveedor, por defecto DESCONOCIDO',
    phone_number VARCHAR(20) NOT NULL DEFAULT 'N/A' COMMENT 'Número de teléfono del proveedor, por defecto NA',
    supplier_status ENUM('active', 'inactive') DEFAULT 'active' COMMENT 'Estado del proveedor, por defecto en active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de creación del registro',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Fecha y hora de actualización del registro',
    CONSTRAINT pk_supplier PRIMARY KEY (id_supplier),
    KEY idx_supplier_name (supplier_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de proveedores';

CREATE TABLE visit_day (
	id_visit_day INT AUTO_INCREMENT COMMENT 'Identificador único del día de visita',
    day_name ENUM('Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo') COMMENT 'Nombre del día de visita',
    CONSTRAINT pk_visit_day PRIMARY KEY (id_visit_day),
    CONSTRAINT uc_day_name UNIQUE KEY (day_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de días de visita';

CREATE TABLE supplier_visit_day (
	id_supplier INT NOT NULL COMMENT 'Identificador único del proveedor',
    id_visit_day INT NOT NULL COMMENT 'Identificador único del día de visita',
    CONSTRAINT pk_supplier_visit_day PRIMARY KEY (id_supplier, id_visit_day),
    CONSTRAINT fk_supplier_visit_day_supplier FOREIGN KEY (id_supplier) REFERENCES supplier(id_supplier)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_supplier_visit_day_visit_day FOREIGN KEY (id_visit_day) REFERENCES visit_day(id_visit_day)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Relación entre proveedores y días de visita';

CREATE TABLE product_supplier (
	id_product INT NOT NULL COMMENT 'Identificador único del producto',
    id_supplier INT NOT NULL COMMENT 'Identificador único del proveedor',
    CONSTRAINT pk_product_supplier PRIMARY KEY (id_product, id_supplier),
    CONSTRAINT fk_product_supplier_product FOREIGN KEY (id_product) REFERENCES product (id_product)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_product_supplier_supplier FOREIGN KEY (id_supplier) REFERENCES supplier (id_supplier)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Relación entre productos y proveedores';

CREATE TABLE status_code (
	id_status_code INT AUTO_INCREMENT COMMENT 'Identificador único del estado',
    type_status ENUM('pendiente', 'completo', 'cancelado') NOT NULL COMMENT 'Tipo de estado',
    CONSTRAINT pk_status_code PRIMARY KEY (id_status_code),
    CONSTRAINT uq_type_status UNIQUE KEY (type_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de estados';
-- ('pending', 'completed', 'canceled')

CREATE TABLE `order` (
	id_order INT AUTO_INCREMENT COMMENT 'Identificador único del pedido',
    id_user INT NOT NULL COMMENT 'Identificador único del usuario que realiza el pedido',
    id_status_code INT DEFAULT 1 COMMENT 'Identificador único del estado del pedido, por defecto en 1 (pendiente)',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora del pedido',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT 'Monto toal del pedido',
    CONSTRAINT pk_order PRIMARY KEY (id_order),
    CONSTRAINT fk_order_user FOREIGN KEY (id_user) REFERENCES `user`(id_user)
	ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_status_code FOREIGN KEY (id_status_code) REFERENCES status_code(id_status_code)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de pedidos';

CREATE TABLE order_item (
	id_order INT NOT NULL COMMENT 'Identificador único del pedido',
    id_product INT NOT NULL COMMENT 'Identificador único del producto',
    quantity INT NOT NULL COMMENT 'Cantidad del producto',
    price DECIMAL(10, 2) NOT NULL COMMENT 'Precio del producto en el pedido',
    product_type ENUM('unit', 'weight') NOT NULL COMMENT 'Tipo de producto',
    subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (
		CASE 
            WHEN product_type = 'weight' 
            THEN quantity * price / 1000
            ELSE quantity * price
        END) STORED COMMENT 'Subtotal del producto en el pedido',
    CONSTRAINT pk_order_item PRIMARY KEY (id_order, id_product),
    CONSTRAINT fk_order_item_order FOREIGN KEY (id_order) REFERENCES `order`(id_order)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_order_item_product FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de detalles del pedido';

CREATE TABLE sale (
	id_sale INT AUTO_INCREMENT COMMENT 'Identificador único de la venta',
    id_user INT NOT NULL COMMENT 'Identificador único del usuario que realiza la venta',
    id_status_code INT DEFAULT 2 COMMENT 'Identificador único del estado de la venta, por defecto en 2 (completado)',
    sale_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Fecha y hora de la venta',
    total_amount DECIMAL(10, 2) NOT NULL COMMENT 'Monto total de la venta',
    CONSTRAINT pk_sale PRIMARY KEY (id_sale),
    CONSTRAINT fk_sale_user FOREIGN KEY (id_user) REFERENCES `user`(id_user)
	ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sale_status_code FOREIGN KEY (id_status_code) REFERENCES status_code(id_status_code)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de ventas';

CREATE TABLE sale_item (
	id_sale INT NOT NULL COMMENT 'Identificador único de la venta',
    id_product INT NOT NULL COMMENT 'Identificador único del producto',
    quantity INT NOT NULL COMMENT 'Cantidad del producto',
    price DECIMAL(10, 2) NOT NULL COMMENT 'Precio del producto en venta',
    product_type ENUM('unit', 'weight') NOT NULL COMMENT 'Tipo de producto',
    subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (
		CASE 
            WHEN product_type = 'weight' 
            THEN quantity * price / 1000
            ELSE quantity * price
        END) STORED COMMENT 'Subtotal del producto en el pedido',
    CONSTRAINT pk_sale_item PRIMARY KEY (id_sale, id_product),
    CONSTRAINT fk_sale_item_sale FOREIGN KEY (id_sale) REFERENCES sale(id_sale)
    ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_sale_item_product FOREIGN KEY (id_product) REFERENCES product(id_product)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT 'Tabla de detalles de venta';
-- subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (quantity * price) STORED COMMENT 'Subtotal del producto en el pedido',










