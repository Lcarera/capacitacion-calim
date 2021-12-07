
-- No borrar los siguientes comentarios, los dejo acá porque se usan seguido.
    -- Inicio: corregir pagos incorrectos:
        /*
        \set movimiento_pago_correcto 6375261
        \set movimiento_a_borrar 5899122
        \set movimiento_a_corregir 5892637
        update movimiento_cuenta set pago_id = (select pago_id from movimiento_cuenta where id = :movimiento_pago_correcto) where id = :movimiento_a_corregir;
        delete from movimiento_cuenta where id = :movimiento_a_borrar;
        */
        -- Luego se debe disparar al action recalcularSaldo del controller cuenta con el id de la misma.
    -- Fin: corregir pagos incorrectos:

    -- Inicio: mover movimientos entre cuentas duplicadas antes de borrarlos:
        /*
        \set cuenta_a_borrar 4815553
        \set cuenta_permanente 4870957
        update movimiento_cuenta set cuenta_id = :cuenta_permanente where cuenta_id = :cuenta_a_borrar;
        update factura_cuenta set cuenta_id = :cuenta_permanente where cuenta_id = :cuenta_a_borrar;
        update pago_cuenta set cuenta_id = :cuenta_permanente where cuenta_id = :cuenta_a_borrar;
        update item_servicio set cuenta_id = :cuenta_permanente where cuenta_id = :cuenta_a_borrar;
        -- Las siguientes líneas deben ser usadas sólo en caso de que la cuenta permanente NO tenga el primer pago pero SÍ lo tenga la que será borrada
        -- update cuenta set primera_facturasmpaga_id = (select primera_facturasmpaga_id from cuenta where id = :cuenta_a_borrar) where id = :cuenta_permanente;
        -- update cuenta set primera_facturasepaga_id = (select primera_facturasepaga_id from cuenta where id = :cuenta_a_borrar) where id = :cuenta_permanente;
    -- Fin: mover movimientos entre cuentas duplicadas antes de borrarlos:
        */
