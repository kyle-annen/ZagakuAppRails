export interface IApi {
  get: (string, number) => Promise<object>
}

