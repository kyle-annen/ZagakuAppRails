import {IApi} from "./iapi";

export default class TopicApi implements IApi {
  get (model: string, id: number): Promise<object> {
    const path = `/api/v1/${model}/${id}`;

    return fetch(path, {
      method: 'GET',
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Cache': 'no-cache'
      },
      credentials: 'same-origin'
    }).then((response) => {
      return response.json();
    }).then((result) => { return result })
  }
}