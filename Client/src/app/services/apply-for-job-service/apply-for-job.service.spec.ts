import { TestBed } from '@angular/core/testing';

import { ApplyForJobService } from './apply-for-job.service';

describe('ApplyForJobService', () => {
  let service: ApplyForJobService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(ApplyForJobService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
