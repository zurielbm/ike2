<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('invoice_items', function (Blueprint $table) {
            $table->integer('invoice_id')->unsigned()->nullable()->change();
            $table->unsignedBigInteger('recurring_invoice_id')->nullable();
            $table->foreign('recurring_invoice_id')->references('id')->on('recurring_invoices');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('invoice_items', function (Blueprint $table) {
            if (config('database.default') !== 'sqlite') {
                $table->dropForeign(['recurring_invoice_id']);
            }
            $table->dropColumn('recurring_invoice_id');
        });
    }
};