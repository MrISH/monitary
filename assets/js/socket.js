import {Socket} from "phoenix"

let socket = new Socket("/socket")

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// MUNS ////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

// ASSIGNS
let munsChannel   = socket.channel("mun:index", {}, socket)
let munsContainer = $("table.muns tbody")

// Joining munsChannel
// probably need to handle ok?/error responses here, for user feedback
munsChannel.join()
  .receive("ok", resp => {
    console.log("Joined Muns successfully", resp)
  })
  .receive("error", resp => {
    console.log("Unable to join Muns", resp)
  })

// Append a row to muns table, for after create
function appendToMunsTable(mun) {
  let munRow = '<tr id="mun_' + mun.id + '">' +
    '<td>' +
      mun.id +
    '</td>' +
    '<td>' +
      mun.name +
    '</td>' +
    '<td>' +
      '<a href="/muns/' + mun.id + '">Show</a>' +
      ' | ' +
      '<a href="/muns/' + mun.id + '/edit">Edit</a>' +
      ' | ' +
      '<a class="delete-mun" data-confirm="Are you sure you want to delete this Mun?" href="#" id="' + mun.id + '">Delete</a>'
    '</td>' +
  '</tr>'
  // Append row to table
  $(munsContainer).after(munRow);
  // Hide modal
  $('#createMunModal').modal('hide');
  // Blank out modal form fields
  $('#createMunModal').find('#mun_name').val('')
  $('#createMunModal').find('#mun_description').val('')
  // Attach on-click event to new row's delete link/button
  $(document).on("click", "tr#mun_" + mun.id + " a.delete-mun", function() {
    munsChannel.push("mun:delete", { id: mun.id })
  })
}

// Remove a row from muns table, for after delete
function removeFromMunsTable(payload) {
  $("tr#mun_" + payload.id).remove()
}

// Trigger Create a new Mun
$(document).on("click", "#createMunModal .actions .btn.submit", function() {
  // Get the vals from the form
  let mun_name        = $(this).closest("form").find("#mun_name").val()
  let mun_description = $(this).closest("form").find("#mun_description").val()
  // Build the params
  let mun_params      = {
    name:         mun_name,
    description:  mun_description,
  }
  // Send to channel
  munsChannel.push("mun:create", { mun: mun_params })
})

// Trigger delete a Mun
$('body').on("click", "a.delete-mun", function() {
  munsChannel.push("mun:delete", { id: this.id })
})

// Handle mun:create response
munsChannel.on("mun:create", payload => {
  appendToMunsTable(payload)
});

// Handle mun:delete response
munsChannel.on("mun:delete", payload => {
  removeFromMunsTable(payload)
});


//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////// TRANSACTIONS ////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

// ASSIGNS
let transactionsChannel   = socket.channel("transaction:index", {}, socket)
let transactionsContainer = $("table.transactions tbody")

// Joining transactionsChannel
transactionsChannel.join()
  .receive("ok", resp => {
    console.log("Joined Transactions successfully", resp)
  })
  .receive("error", resp => {
    console.log("Unable to join Transactions", resp)
  })

// Append a row to muns table, for after create
function appendToTransactionsTable(transaction) {
  let transactionRow = '<tr id="transaction_' + transaction.id + '">' +
    '<td>' +
      transaction.id +
    '</td>' +

    '<td>' +
      transaction.amount_in_cents +
    '</td>' +
    '<td>' +
      transaction.settlement_date +
    '</td>' +
    '<td>' +
      transaction.classification +
    '</td>' +
    '<td>' +
      transaction.source_id +
    '</td>' +

    '<td>' +
      '<a href="/muns/' + transaction.mun_id + '/transactions/' + transaction.id + '">Show</a>' +
      ' | ' +
      '<a href="/muns/' + transaction.mun_id + '/transactions/' + transaction.id + '/edit">Edit</a>' +
      ' | ' +
      '<a href="/muns/' + transaction.mun_id + '/transactions/' + transaction.id + '/items">Items</a>' +
      ' | ' +
      '<a class="delete-transaction" data-confirm="Are you sure you want to delete this Transaction?" href="#" id="' + transaction.id + '">Delete</a>'
    '</td>' +
  '</tr>'
  // Append row to table
  $(transactionsContainer).after(transactionRow);
  // Hide modal
  $('#createTransactionModal').modal('hide');
  // Blank out modal form fields
  $('#createTransactionModal').find("#transaction_mun_id").val('')
  $('#createTransactionModal').find("#transaction_amount_in_cents").val('')
  $('#createTransactionModal').find("#transaction_settlement_date").val('')
  $('#createTransactionModal').find('[name="transaction[classification]"]').prop('checked', false);
  $('#createTransactionModal').find("#transaction_source_id").val('')
  // Attach on-click event to new row's delete link/button
  $(document).on("click", "tr#transaction_" + transaction.id + " a.delete-transaction", function() {
    transactionsChannel.push("transaction:delete", { id: transaction.id })
  })
}

function itemToRow(item) {
  let itemRow = '<tr id="item_' + item.id + '">' +
    '<td>' +
      item.id +
    '</td>' +
    '<td>' +
      item.name +
    '</td>' +
    '<td>' +
      item.amount_in_cents +
    '</td>' +
    '<td>' +
      item.quantity +
    '</td>' +
    '<td>' +
      // actions
    '</td>' +
  '</tr>'
  return itemRow
}

// Remove a row from transactions table, for after delete
function removeFromTransactionsTable(payload) {
  $("tr#transaction_" + payload.id).remove()
}

// Loads this Transaction's Items into transactionItemListModal modal
function updateTransactionItemsList(items) {
  // Clear table body
  $('table.transaction-items body').html('');
  // Loop payload array.
  $.each(items, function(index, item) {
    // Build table row for each item.
    // Append to table body
    $('table.transaction-items tbody').after(itemToRow(item));
  })
}

// Trigger Create a new Transaction
$(document).on("click", "#createTransactionModal .actions .btn.submit", function() {
  // Get the vals from the form
  let mun_id              = $(this).closest("form").find("#transaction_mun_id").val()
  let amount_in_cents     = $(this).closest("form").find("#transaction_amount_in_cents").val()
  let settlement_date     = $(this).closest("form").find("#transaction_settlement_date").val()
  let classification      = $(this).closest("form").find('[name="transaction[classification]"]:checked').val()
  let source_id           = $(this).closest("form").find("#transaction_source_id").val()
  // Build the params
  let transaction_params  = {
    mun_id:          mun_id,
    amount_in_cents: amount_in_cents,
    settlement_date: settlement_date,
    classification:  classification,
    source_id:       source_id,
  }
  // Send to channel
  transactionsChannel.push("transaction:create", { transaction: transaction_params })
})

// Trigger load Transactions Items
$(document).on("click", "table.transactions .open-transaction-items", function() {
  // Send request to channel
  transactionsChannel.push("transaction:get_items", { id: $(this).data("id") })
})

// Trigger Create a new Transaction Item
$(document).on("click", "#createTransactionItemModal .actions .btn.submit", function() {
  // Get the vals from the form
  let mun_id              = $(this).closest("form").find("#transaction_item_mun_id").val()
  let transaction_id      = $(this).closest("form").find("#transaction_item_transaction_id").val()
  let amount_in_cents     = $(this).closest("form").find("#transaction_item_amount_in_cents").val()
  let name                = $(this).closest("form").find("#transaction_item_name").val()
  let quantity            = $(this).closest("form").find("#transaction_item_quantity").val()
  // Build the params
  let transaction_item_params  = {
    mun_id:           mun_id,
    transaction_id:   transaction_id,
    amount_in_cents:  amount_in_cents,
    name:             name,
    quantity:         quantity,
  }
  // Send to channel
  transactionsChannel.push("transaction:create_transaction_item", { transaction_item: transaction_item_params })
})


// Trigger delete a Transaction
$('body').on("click", "a.delete-transaction", function() {
  // Send request to channel
  transactionsChannel.push("transaction:delete", { id: $(this).data("id") })
})

// Handle transaction:create response
transactionsChannel.on("transaction:create", payload => {
  appendToTransactionsTable(payload)
});

// Handle transaction:delete response
transactionsChannel.on("transaction:delete", payload => {
  removeFromTransactionsTable(payload)
});

// Handle transaction:items response
transactionsChannel.on("transaction:get_items", payload => {
  // Refresh Items list
  updateTransactionItemsList(payload.items)
  // Update New Item form..? Or just blank it out?
});


//////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////// GLOBAL BUSINESS ///////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////

// Pass User token to socket connection for authentication
$(document).ready(function() {
  socket.connect({ token: window.userToken })
});
// export (whatever that means)
export default socket
