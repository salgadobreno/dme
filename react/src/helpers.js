export function handleResponse(result, success, fail) {
  if (result.ok) {
    console.log(result);
    result.json().then(json=> {
      if (json.success) {
        console.log('success');
        console.log(this);
        success(json);
      } else {
        console.log('fail');
        fail(json);
      }
    })
  } else {
    fail({message: "response failed: "+result.status})
  }
}
