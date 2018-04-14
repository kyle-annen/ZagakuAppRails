export default class Api {
  get (model: string, id: number, callback: (object) => void): void {
    const path = `/api/v1/${model}/${id}`;

    fetch(path, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cache': 'no-cache'
      },
      credentials: 'same-origin'
    }).then((response) => {
      return response.json();
    }).then((result) => {
      callback(result)
    })
  }
}