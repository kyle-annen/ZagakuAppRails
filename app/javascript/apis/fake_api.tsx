import {IApi} from "./iapi";

class FakeApi implements IApi {
  get (model: string, id: number): Promise<object> {
    window.fetch = jest.fn()
    return Promise.resolve(
      {
        topic: {
          id: id,
          category_id: 1,
          name: "Test Title",
          summary: "Test Summary"
        },
        user_lessons: {},
        parameters: {model: model, id: id}}
    )
  }
}

