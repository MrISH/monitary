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

// Pass User token to socket connection for authentication
$(document).ready(function() {
  socket.connect({ token: window.userToken })
});

// Assigns
let munsChannel   = socket.channel("mun:index", {}, socket)
let munsContainer = $("table.muns tbody")

// Joining munsChannel
// probably need to handle ok?/error responses here, for user feedback
munsChannel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp)
  })
  .receive("error", resp => {
    console.log("Unable to join", resp)
  })

// Trigger Create a new Mun
$(document).on("click", "#createMunModal .actions .btn.submit", function() {
  let mun_name        = $(this).closest("form").find("#mun_name").val()
  let mun_description = $(this).closest("form").find("#mun_description").val()
  let mun_params      = { name: mun_name, description: mun_description }
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

// Handle mun:create response
munsChannel.on("mun:delete", payload => {
  removeFromMunsTable(payload)
});

export default socket
